import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/exceptions/network_exceptions.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:dio/dio.dart';

abstract class PostApi {
  Future<PostList> getPosts();
}

class PostApiImpl extends PostApi {
  // dio instance
  final Dio _dio;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  PostApiImpl(this._dio, this._restClient);

  /// Returns list of post in response
  @override
  Future<PostList> getPosts() async {
    print("dio instance: ${_dio.hashCode}");
    try {
      final res = await _dio.get(Endpoints.getPosts);
      return PostList.fromJson(res.data);
    } on DioError catch (e) {
      print(e.toString());
      throw NetworkException(
          message: e.message, statusCode: e.response.statusCode);
    }
  }

  /// sample api call with default rest client
//  Future<PostsList> getPosts() {
//
//    return _restClient
//        .get(Endpoints.getPosts)
//        .then((dynamic res) => PostsList.fromJson(res))
//        .catchError((error) => throw NetworkException(message: error));
//  }

}
