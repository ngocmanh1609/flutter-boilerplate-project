import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:dio/dio.dart';

class ApplicationInterceptor extends Interceptor {
  final bool requireAuthenticate;
  final SharedPreferenceHelper sharedPrefHelper;

  ApplicationInterceptor({this.requireAuthenticate, this.sharedPrefHelper});

  @override
  Future onRequest(RequestOptions options) async {
    print("vao onRequest");
    if (requireAuthenticate && sharedPrefHelper != null) {
      print("need authenticate block");
      String token = await sharedPrefHelper.authToken;
      print("token la: $token");
      if (token != null) {
        options.headers.putIfAbsent('Authorization', () => token);
      } else {
        print('Auth token is null');
      }
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    // TODO: implement onResponse
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    // TODO: implement onError
    return super.onError(err);
  }
}
