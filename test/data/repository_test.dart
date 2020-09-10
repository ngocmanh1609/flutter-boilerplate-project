import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/network/apis/non_authenticated_post_api.dart';
import 'package:boilerplate/data/network/apis/posts/post_api.dart';
import 'package:boilerplate/data/network/exceptions/network_exceptions.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPostDataSource extends Mock implements PostDataSource {}

class MockPostApi extends Mock implements PostApi {}

class MockNonAuthenticatedPostApi extends Mock
    implements NonAuthenticatedPostApi {}

class MockSharedPreferenceHelper extends Mock
    implements SharedPreferenceHelper {}

void main() {
  PostDataSource _mockPostDataSource;
  PostApi _mockPostApi;
  NonAuthenticatedPostApi _mockNonAuthenticatedPostApi;
  SharedPreferenceHelper _mockSharedPreferenceHelper;
  Repository _repository;

  setUp(() {
    _mockPostDataSource = MockPostDataSource();
    _mockPostApi = MockPostApi();
    _mockNonAuthenticatedPostApi = MockNonAuthenticatedPostApi();
    _mockSharedPreferenceHelper = MockSharedPreferenceHelper();
    _repository = RepositoryImpl(_mockPostApi, _mockNonAuthenticatedPostApi,
        _mockSharedPreferenceHelper, _mockPostDataSource);
  });

  test("When fetching posts successfully, it returns postList correctly",
      () async {
    final _postList = PostList.fromJson([
      {
        "userId": 1,
        "id": 1,
        "title": "ok",
        "body": "hihi",
      }
    ]);
    when(_mockPostApi.getPosts()).thenAnswer((_) async => _postList);

    when(_mockPostDataSource.insert(any)).thenAnswer((_) async => 1);

    expect(await _repository.getPosts(), _postList);

    expect(
        await _repository
            .getPosts()
            .then((postList) => postList.posts[0].userId),
        1);
  });

  test("When fetching posts failed, it throws error", () {
    when(_mockPostApi.getPosts()).thenThrow(NetworkException());

    when(_mockPostDataSource.insert(any)).thenAnswer((_) async => 1);

    expectLater(() => _repository.getPosts(), throwsException);
  });
}
