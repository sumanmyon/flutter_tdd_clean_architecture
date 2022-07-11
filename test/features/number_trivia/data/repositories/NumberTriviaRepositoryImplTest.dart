import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/Exceptions.dart';
import 'package:flutter_tdd_clean_architecture/core/error/Failures.dart';
import 'package:flutter_tdd_clean_architecture/core/network/NetworkInfo.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/NumberTriviaLocalDataSource.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/NumberTriviaRemoteDataSource.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/repositories/NumberTriviaRepositoryImpl.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl? repository;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource!,
      localDataSource: mockLocalDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });

  void runTestOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo?.isConnected)
            .thenAnswer((realInvocation) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo?.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      body();
    });
  }

  group("get concrete number trivia", () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "Test Trivia 1");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("if device is online", () async {
      //arrenge
      when(mockNetworkInfo?.isConnected)
          .thenAnswer((realInvocation) async => true);

      //act
      repository?.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockNetworkInfo?.isConnected);
    });

    runTestOnline(() {
      test(
          "should return remote data when call to remote data source is successful",
          () async {
        //arrange
        when(mockRemoteDataSource?.getConcreteNumberTrivia(tNumber))
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        //act
        final result = await repository?.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockRemoteDataSource?.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          "should cache data locally when the call to remote data source is successful",
          () async {
        //arrange
        when(mockRemoteDataSource?.getConcreteNumberTrivia(tNumber))
            .thenAnswer((realInvocation) async => tNumberTriviaModel);

        //act
        await repository?.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockLocalDataSource?.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          "should return server failure when call to remote data source is unsuccessful",
          () async {
        //arrange
        when(mockRemoteDataSource?.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerExceptions());

        //act
        final result = await repository?.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockRemoteDataSource?.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailures())));
      });
    });

    runTestOffline(() {
      setUp(() {
        when(mockNetworkInfo?.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      test(
        "should return last locally cached data when the cached data is present",
        () async {
          //arrange
          when(mockLocalDataSource?.getLastNumberTrivia())
              .thenAnswer((realInvocation) async => tNumberTriviaModel);

          //act
          final result = await repository?.getConcreteNumberTrivia(tNumber);

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource?.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        "should return cached failure when the no cached data is present",
        () async {
          //arrange
          when(mockLocalDataSource?.getLastNumberTrivia())
              .thenThrow(CacheExceptions());

          //act
          final result = await repository?.getConcreteNumberTrivia(tNumber);

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource?.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailures())));
        },
      );
    });
  });


  group("get random number trivia", () {
    final tNumberTriviaModel =
    NumberTriviaModel(number: 1, text: "Test Trivia 1");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("if device is online", () async {
      //arrenge
      when(mockNetworkInfo?.isConnected)
          .thenAnswer((realInvocation) async => true);

      //act
      repository?.getRandomNumberTrivia();

      //assert
      verify(mockNetworkInfo?.isConnected);
    });

    runTestOnline(() {
      test(
          "should return remote data when call to remote data source is successful",
              () async {
            //arrange
            when(mockRemoteDataSource?.getRandomNumberTrivia())
                .thenAnswer((realInvocation) async => tNumberTriviaModel);

            //act
            final result = await repository?.getRandomNumberTrivia();

            //assert
            verify(mockRemoteDataSource?.getRandomNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          });

      test(
          "should cache data locally when the call to remote data source is successful",
              () async {
            //arrange
            when(mockRemoteDataSource?.getRandomNumberTrivia())
                .thenAnswer((realInvocation) async => tNumberTriviaModel);

            //act
            await repository?.getRandomNumberTrivia();

            //assert
            verify(mockLocalDataSource?.cacheNumberTrivia(tNumberTriviaModel));
          });

      test(
          "should return server failure when call to remote data source is unsuccessful",
              () async {
            //arrange
            when(mockRemoteDataSource?.getRandomNumberTrivia())
                .thenThrow(ServerExceptions());

            //act
            final result = await repository?.getRandomNumberTrivia();

            //assert
            verify(mockRemoteDataSource?.getRandomNumberTrivia());
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailures())));
          });
    });

    runTestOffline(() {
      setUp(() {
        when(mockNetworkInfo?.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      test(
        "should return last locally cached data when the cached data is present",
            () async {
          //arrange
          when(mockLocalDataSource?.getLastNumberTrivia())
              .thenAnswer((realInvocation) async => tNumberTriviaModel);

          //act
          final result = await repository?.getRandomNumberTrivia();

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource?.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        "should return cached failure when the no cached data is present",
            () async {
          //arrange
          when(mockLocalDataSource?.getLastNumberTrivia())
              .thenThrow(CacheExceptions());

          //act
          final result = await repository?.getRandomNumberTrivia();

          //assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource?.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailures())));
        },
      );
    });
  });
}
