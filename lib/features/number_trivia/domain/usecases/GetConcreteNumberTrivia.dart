import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tdd_clean_architecture/core/error/Failures.dart';
import 'package:flutter_tdd_clean_architecture/core/usecases/Usecase.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/NumberTriviaRepository.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, Params> {
  final NumberTriviaRepository numberTriviaRepository;

  GetConcreteNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failures, NumberTrivia>>? call({Params? params}) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(params!.number!)!;
  }

// Future<Either<Failures, NumberTrivia>>? call({
//   required int number,
// }) async {
//   return await numberTriviaRepository.getConcreteNumberTrivia(number)!;
// }
}

class Params extends Equatable {
  late int? number;

  Params({@required this.number});

  @override
  List<Object?> get props => [number];
}
