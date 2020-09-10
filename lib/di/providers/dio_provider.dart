import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/di/interceptors/application_interceptor.dart';
import 'package:dio/dio.dart';

class DioProvider {
  Dio _authenticatedDio;
  Dio _nonAuthenticatedDio;
  SharedPreferenceHelper _sharedPreferenceHelper;

  DioProvider(this._sharedPreferenceHelper);

  Dio getDio(String baseUrl, bool requireAuthenticate) {
    if (requireAuthenticate) {
      if (_authenticatedDio == null) {
        _authenticatedDio = _assembleDio(
            baseUrl: baseUrl,
            requireAuthenticate: requireAuthenticate,
            sharedPreferenceHelper: _sharedPreferenceHelper);
      }
      return _authenticatedDio;
    } else {
      if (_nonAuthenticatedDio == null) {
        _nonAuthenticatedDio = _assembleDio(
            baseUrl: baseUrl,
            requireAuthenticate: false,
            sharedPreferenceHelper: null);
      }
      return _nonAuthenticatedDio;
    }
  }

  Dio _assembleDio(
      {String baseUrl,
      bool requireAuthenticate = false,
      SharedPreferenceHelper sharedPreferenceHelper}) {
    final dio = Dio();
    final applicationInterceptor = ApplicationInterceptor(
        requireAuthenticate: requireAuthenticate,
        sharedPrefHelper: sharedPreferenceHelper);
    final logInterceptor = LogInterceptor(
      request: true,
      responseBody: true,
      requestBody: true,
      requestHeader: true,
    );
    final interceptors = List<Interceptor>();
    interceptors.add(applicationInterceptor);
    interceptors.add(logInterceptor);
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.headers = {HEADER_CONTENT_TYPE: DEFAULT_CONTENT_TYPE}
      ..interceptors.addAll(interceptors);
    return dio;
  }
}

const String HEADER_CONTENT_TYPE = 'Content-Type';
const String DEFAULT_CONTENT_TYPE = 'application/json; charset=utf-8';
