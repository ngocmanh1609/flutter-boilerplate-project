import 'package:boilerplate/bloc/language_bloc.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  Repository _mockRepository;

  LanguageBloc _bloc;

  setUp(() {
    _mockRepository = MockRepository();
    _bloc = LanguageBlocImpl(_mockRepository);
  });

  test("When initializing Bloc, the locale should be EN as default", () {
    expectLater(_bloc.locale, emits("en"));
  });
}
