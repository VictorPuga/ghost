import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bungie_api/models/destiny_character_component.dart';
import 'package:bungie_api/models/destiny_inventory_item_definition.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ghost/blocs/progress/progress.dart';
import 'package:ghost/keys.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:bungie_api/models/destiny_manifest.dart';

class DBRepository {
  final ProgressBloc progressBloc;

  DBRepository({
    this.progressBloc,
  }) : _dio = _initClient();

  /// Path of the app's documents directory
  static final Future<String> _dbPath = getDatabasesPath();

  final Dio _dio;

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Dio _initClient() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://www.bungie.net',
      headers: {'X-API-Key': bungieAPIKey},
    ));
    (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    return dio;
  }

  Future<Database> _initDB(String name) async {
    final String path = join(await _dbPath, name);
    final Database database = await openDatabase(
      path,
      readOnly: true,
      // singleInstance: false,
      onOpen: (Database db) async {
        // print('opened!');
      },
    );

    return database;
  }

  Future<String> getManifestVersion() async {
    final String version = await _storage.read(key: 'manifestVersion');
    return version;
  }

  Future getDefinitionsAndAssets(DestinyManifest manifest) async {
    // Will become a Locale instance
    const String locale = 'en';
    dynamic error;

    try {
      // await _downloadAndSave(
      //   manifest.mobileAssetContentPath,
      //   'mobileAssetContent',
      //   [1, 2],
      // );
      await _downloadAndSave(
        manifest.mobileWorldContentPaths[locale],
        'mobileWorldContent',
        [1, 1],
      );

      await _storage.write(key: 'manifestVersion', value: manifest.version);
    } catch (e) {
      error = e;
      print('Error:\n$e');
    } finally {
      if (error == null) {
      } else {}
    }
  }

  Future<void> deleteOldDbs() async {
    final String dbPath = await _dbPath;
    List<String> paths = [
      // join(dbPath, 'mobileAssetContent.sql'),
      join(dbPath, 'mobileWorldContent.sql'),
    ];

    await Future.forEach(paths, (path) async {
      if (await databaseExists(path)) {
        await deleteDatabase(path);
      }
    });
  }

  Future<List<DestinyInventoryItemDefinition>> getItemData(
    List<int> itemHashes,
  ) async {
    final List<int> ids = itemHashes.map((hash) => unHash(hash)).toList();

    final String placeholders = List.filled(ids.length, '?').join(',');

    final List<Map<String, dynamic>> results = await _query(
      'DestinyInventoryItemDefinition',
      where: 'id In ($placeholders)',
      whereArgs: ids,
    );

    final List<DestinyInventoryItemDefinition> definitions = results
        .map((d) => DestinyInventoryItemDefinition.fromJson(d['json']))
        .toList();

    return definitions;
  }

  Future<Map<int, Bucket>> getBucketData(List<int> hashes) async {
    final List<int> ids = hashes.map((hash) => unHash(hash)).toList();
    final String placeholders = List.filled(ids.length, '?').join(',');

    final List<Map<String, dynamic>> results = await _query(
      'DestinyInventoryBucketDefinition',
      where: 'id In ($placeholders)',
      whereArgs: ids,
    );

    final Map<int, Bucket> buckets = Map.fromEntries(
      results.map(
        (b) {
          final bucket = Bucket.fromJson(b['json']);
          return MapEntry(bucket.hash, bucket);
        },
      ),
    );

    return buckets;
  }

  Future<List<CharacterData>> getCharacterData(
    List<DestinyCharacterComponent> characters,
  ) async {
    final List<CharacterData> characterData = [];
    for (final c in characters) {
      final res1 = await _query(
        'DestinyClassDefinition',
        where: 'id = ?',
        whereArgs: [unHash(c.classHash)],
      );
      final res2 = await _query(
        'DestinyRaceDefinition',
        where: 'id = ?',
        whereArgs: [unHash(c.raceHash)],
      );

      final String className = res1.first['json']
          ['genderedClassNamesByGenderHash']['${c.genderHash}'];

      final String raceName = res2.first['json']
          ['genderedRaceNamesByGenderHash']['${c.genderHash}'];

      characterData.add(
        CharacterData(className: className, raceName: raceName),
      );
    }

    return characterData;
  }

  Future<void> _downloadAndSave(
    String path,
    String name,
    List<int> progress,
  ) async {
    assert(progressBloc != null);

    final Response<List<int>> response = await _get(
      path,
      current: progress[0],
      total: progress[1],
    );
    final Archive archive = ZipDecoder().decodeBytes(response.data);
    progressBloc.dispatch(
      ProgressUpdate(
        progress: 1,
        status: 'Installing',
        isLoading: true,
      ),
    );
    for (final ArchiveFile file in archive) {
      final String fileName =
          // withoutExtension(basename(file.name)) +
          name + '.sql';
      if (file.isCompressed) {
        file.decompress();
      }

      final String path = join(await _dbPath, fileName);

      await File(path).writeAsBytes(file.content);
    }
  }

  Future<Response<List<int>>> _get(
    String path, {
    int current = 1,
    int total = 1,
  }) async {
    assert(progressBloc != null);
    final Response<List<int>> response = await _dio.get(
      path,
      options: Options(responseType: ResponseType.bytes),
      onReceiveProgress: (progress, totalBytes) {
        progressBloc.dispatch(
          ProgressUpdate(
            progress: progress / totalBytes,
            status: 'Downloading assets: $current of $total',
            isLoading: true,
          ),
        );
      },
    );
    if (response.headers.contentType == ContentType.html) {
      throw Exception('Request failed with status ${response.statusCode}');
    }
    return response;
  }

  Future<List<Map<String, dynamic>>> _query(
    String table, {
    String where,
    List<dynamic> whereArgs,
  }) async {
    // print('querying...');

    final Database database = await _initDB('mobileWorldContent.sql');

    List<Map<String, dynamic>> results = await database.query(
      table,
      where: where,
      whereArgs: whereArgs,
    );
    final List<Map<String, dynamic>> newList = [];

    results.forEach((r) {
      final result = {
        'id': r['id'],
        'json': jsonDecode(r['json']),
      };
      newList.add(result);
    });

    return newList;
  }
}
