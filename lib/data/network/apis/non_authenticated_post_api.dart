import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:dio/dio.dart';

abstract class NonAuthenticatedPostApi {
  Future<PostList> getPosts();
}

class NonAuthenticatedPostApiImpl extends NonAuthenticatedPostApi {
  final Dio _dio;
  NonAuthenticatedPostApiImpl(this._dio);

  /// Returns list of post in response
  @override
  Future<PostList> getPosts() async {
    print("dio instance: ${_dio.hashCode}");
    try {
      final res = await _dio.get(Endpoints.getPosts);
      return PostList.fromJson(res.data);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
