import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/Exceptions.dart';
import 'package:flutter_tdd_clean_architecture/core/error/Failures.dart';
import 'package:flutter_tdd_clean_architecture/core/network/NetworkInfo.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/NumberTriviaLocalDataSource.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/NumberTriviaRemoteDataSource.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/NumberTriviaRepository.dart';

typedef Future<NumberTriviaModel>? _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failures, NumberTrivia>>? getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    })!;
  }

  @override
  Future<Either<Failures, NumberTrivia>>? getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    })!;
  }

  Future<Either<Failures, NumberTrivia>>? _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    bool isConnected = await networkInfo.isConnected!;

    if (isConnected) {
      try {
        var remoteTrivia = await getConcreteOrRandom();
        if (remoteTrivia == null) {
          return Right(NumberTrivia(number: -1, text: ""));
        } else {
          await localDataSource.cacheNumberTrivia(remoteTrivia);
          return Right(remoteTrivia);
        }
      } on ServerExceptions {
        return Left(ServerFailures());
      }
    } else {
      try {
        var localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia!);
      } on CacheExceptions {
        return Left(CacheFailures());
      }
    }
  }
}
