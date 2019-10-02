import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ghost/utils.dart';
import 'package:bungie_api/helpers/http.dart';
import 'keys.dart';

String joinParams([Map params = const {}]) {
  if (params?.isEmpty ?? true) return '';

  List p = [];
  params.forEach((k, v) {
    dynamic val = v;
    if (val is List) {
      val = val.join(',');
    } else if (val is! String && val is! num && val is! bool && val != null) {
      throw Exception(
        'Parameter values cannot be other than `List`, `String`, `bool`, `num`, or `null`',
      );
    }
    p.add([k, val].join('='));
  });

  return '?' + p.join('&');
}

class _DestinyClient extends HttpClient {
  static final Dio _dio = _initClient();

  static Dio _initClient() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://www.bungie.net/platform',
      headers: {'X-API-Key': bungieAPIKey},
    ));
    (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    return dio;
  }

  @override
  Future<HttpResponse> request(HttpClientConfig config) async {
    Response r;
    try {
      r = await _dio.request(
        config.url + joinParams(config.params),
        data: config.body,
        options: Options(
          method: config.method,
          headers: config.headers ?? {},
        ),
      );
      // } on DioError catch (e) {
      //   if (e.type == DioErrorType.RESPONSE) {
      //     // print(e.error);
      //     // print(e.stackTrace);
      //     return HttpResponse(e.response.data, e.response.statusCode);
      //   }
    } catch (e) {}

    return HttpResponse(r.data, r.statusCode);
  }
}

class _AirtableClient extends HttpClient {
  static final Dio _dio = _initClient();

  static Dio _initClient() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.airtable.com/v0/' + airtableSetId,
      headers: {
        'Authorization': 'Bearer ' + airtableAPIKey,
        'Content-Type': 'application/json'
      },
    ));
    (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    return dio;
  }

  @override
  Future<HttpResponse> request(HttpClientConfig config) async {
    Response r;
    try {
      r = await _dio.request(
        config.url + joinParams(config.params),
        data: config.body,
        options: Options(
          method: config.method,
          headers: config.headers ?? {},
        ),
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        // print(e.error);
        // print(e.stackTrace);
        return HttpResponse(e.response.data, e.response.statusCode);
      }
    }
    return HttpResponse(r.data, r.statusCode);
  }
}

final destinyClient = _DestinyClient();
final airtableClient = _AirtableClient();
