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

class DestinyClient extends HttpClient {
  static final Dio _dio = _initClient();
  final String accessToken;

  DestinyClient([this.accessToken]);

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
          headers: accessToken == null
              ? {}
              : {
                  'Authorization': 'Bearer ' + accessToken,
                },
        ),
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        print('Error in destinyClient');
        print(e.response.data);
        // print(e.stackTrace);
        throw HttpResponse(e.response.data, e.response.statusCode);
      }
    }

    return HttpResponse(r.data, r.statusCode);
  }
}
