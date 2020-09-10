import 'package:bloc_provider/bloc_provider.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

abstract class PostBloc implements Bloc {
  ValueStream<PostList> get postList;
  ValueStream<bool> get isLoading;
  ValueStream<String> get error;

  void getPosts();

  void getNonAuthenticatedPosts();
}

class PostBlocImpl extends PostBloc {
  // repository instance
  Repository _repository;

  PostBlocImpl(this._repository);

  final _postList = BehaviorSubject<PostList>();
  final _isLoading = BehaviorSubject<bool>();
  final _error = BehaviorSubject<String>();

  @override
  ValueStream<PostList> get postList => _postList;

  @override
  ValueStream<bool> get isLoading => _isLoading;

  @override
  ValueStream<String> get error => _error;

  @override
  void getPosts() async {
    _isLoading.add(true);
    final future = _repository.getPosts();

    future.then((postList) {
      _postList.add(postList);
      _isLoading.add(false);
    }).catchError((error) {
      _isLoading.add(false);
      _error.add(DioErrorUtil.handleError(error));
    });
  }

  @override
  void getNonAuthenticatedPosts() async {
    final future = _repository.getNonAuthenticatedPosts();
    future.then((postList) {
      print('get successfully');
    }).catchError((error) {
      print("$error");
    });
  }

  @override
  void dispose() {
    _postList.close();
    _isLoading.close();
    _error.close();
  }
}
