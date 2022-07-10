import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_clean_architecture/core/error/Failures.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';

abstract class Usecase<Type, Params>{
  Future<Either<Failures, NumberTrivia>>? call({Params? params});
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}