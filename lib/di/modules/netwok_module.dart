import 'package:boilerplate/data/network/apis/non_authenticated_post_api.dart';
import 'package:boilerplate/data/network/apis/posts/post_api.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/di/modules/preference_module.dart';
import 'package:boilerplate/di/providers/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:inject/inject.dart';

@module
class NetworkModule extends PreferenceModule {
  // ignore: non_constant_identifier_names
  final String TAG = "NetworkModule";

  // DI Providers:--------------------------------------------------------------
  /// A singleton dio provider.
  ///
  /// Calling it multiple times will return the same instance.
  // @provide
  // @singleton
  // Dio provideDio(DioProvider dioProvider) {
  //   return dioProvider.getDio(Endpoints.baseUrl, true);
  // }

  @provide
  @singleton
  DioProvider createDioProvider(SharedPreferenceHelper sharedPreferenceHelper) {
    return DioProvider(sharedPreferenceHelper);
  }

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.
  // @provide
  // @singleton
  // DioClient provideDioClient(Dio dio) => DioClient(dio);

  /// A singleton dio_client provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  RestClient provideRestClient() => RestClient();

  // Api Providers:-------------------------------------------------------------
  // Define all your api providers here
  /// A singleton post_api provider.
  ///
  /// Calling it multiple times will return the same instance.
  @provide
  @singleton
  PostApi providePostApi(DioProvider dioProvider, RestClient restClient) =>
      PostApiImpl(_provideAuthenticatedDio(dioProvider), restClient);

  @provide
  @singleton
  NonAuthenticatedPostApi provideNonAuthenticatedApiTest(
          DioProvider dioProvider) =>
      NonAuthenticatedPostApiImpl(_provideNonAuthenticatedDio(dioProvider));
// Api Providers End:---------------------------------------------------------

  Dio _provideAuthenticatedDio(DioProvider dioProvider) {
    return dioProvider.getDio(Endpoints.baseUrl, true);
  }

  Dio _provideNonAuthenticatedDio(DioProvider dioProvider) {
    return dioProvider.getDio(Endpoints.baseUrl, false);
  }
}
