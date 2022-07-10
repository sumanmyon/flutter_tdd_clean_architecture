import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/Failures.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failures, NumberTrivia>>? getConcreteNumberTrivia(int number);

  Future<Either<Failures, NumberTrivia>>? getRandomNumberTrivia();
}
