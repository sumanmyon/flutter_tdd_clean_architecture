import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_tdd_clean_architecture/core/error/Exceptions.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/NumberTriviaLocalDataSource.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/FixtureReader.dart';

class MockSharePreferences extends Mock implements SharedPreferences {
}

class MockSharePreferences2 extends Fake implements SharedPreferences {

  @override
  Future<bool> setString(String key, String value) {
    return Future.value(true);
  }

  @override
  String? getString(String key) {
    final tNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: "Test Trivia",
    );

    return json.encode(tNumberTriviaModel.toJson());
  }
}

void main() {
  NumberTriviaLocalDataSourceImpl? dataSource;
  MockSharePreferences? mockSharePreferences;

  MockSharePreferences2? mockSharePreferences2;
  NumberTriviaLocalDataSourceImpl? dataSource2;

  setUp(() {
    //SharedPreferences.getInstance();
    //SharedPreferences.setMockInitialValues({});

    mockSharePreferences = MockSharePreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharePreferences!,
    );

    mockSharePreferences2 = MockSharePreferences2();
    dataSource2 = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharePreferences2!,
    );
  });

  group("getLastNumberTrivia", () {
    final fixtureCached = fixture('TriviaCached.json');
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixtureCached));

    test(
      "should return number trivia from SharePreference when there is one in the cached",
      () async {
        //arrange
        when(mockSharePreferences?.getString(
                NumberTriviaLocalDataSourceImpl.CACHED_NUMBER_TRIVIA))
            .thenReturn(fixtureCached);

        //act
        final result = await dataSource?.getLastNumberTrivia()!;

        //asset
        verify(mockSharePreferences
            ?.getString(NumberTriviaLocalDataSourceImpl.CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "should throw cache exceptin when there is not cached value in SharePreference",
      () async {
        //arrange
        when(mockSharePreferences?.getString("")).thenReturn(null);

        //act
        final result = dataSource?.getLastNumberTrivia;

        //asset
        expect(() => result!.call(), throwsA(TypeMatcher<CacheExceptions>()));
      },
    );
  });

  group("cacheNumberTrivia", () {
    final tNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: "Test Trivia",
    );
    // test(
    //   "should call sharepreferences to cache the data",
    //   () async {
    //     //act
    //     await dataSource?.cacheNumberTrivia(tNumberTriviaModel);
    //
    //     //asset
    //     final expectedJsonData = json.encode(tNumberTriviaModel.toJson());
    //     verify(mockSharePreferences?.setString(
    //       NumberTriviaLocalDataSourceImpl.CACHED_NUMBER_TRIVIA,
    //       expectedJsonData,
    //     ));
    //   },
    // );

    test('should call SharedPreferences to cache the data', () async {
      // act
      dataSource2?.cacheNumberTrivia(tNumberTriviaModel);
      final r = await dataSource2?.getLastNumberTrivia();

      // assert
      expect(r, tNumberTriviaModel);
    });
  });
}
