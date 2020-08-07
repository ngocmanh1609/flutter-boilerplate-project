import 'package:bloc_provider/bloc_provider.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class PostBloc implements Bloc {
  // repository instance
  Repository _repository;

  PostBloc(this._repository);

  final _postList = BehaviorSubject<PostList>();
  final _isLoading = BehaviorSubject<bool>();
  final _error = BehaviorSubject<String>();

  ValueStream<PostList> get postList => _postList;
  ValueStream<bool> get isLoading => _isLoading;
  ValueStream<String> get error => _error;

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
  void dispose() {
    _postList.close();
    _isLoading.close();
    _error.close();
  }
}
