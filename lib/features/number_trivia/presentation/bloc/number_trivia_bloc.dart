import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_clean_architecture/core/error/Failures.dart';
import 'package:flutter_tdd_clean_architecture/core/usecases/Usecase.dart';
import 'package:flutter_tdd_clean_architecture/core/util/InputConverter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/GetRandomNumberTrivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  GetConcreteNumberTrivia? _getConcreteNumberTrivia;
  GetRandomNumberTrivia? _getRandomNumberTrivia;
  final InputConverter? inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia? concrete,
    required GetRandomNumberTrivia? random,
    required this.inputConverter,
  }) : super(Empty()) {
    assert(concrete != null);
    assert(random != null);
    assert(inputConverter != null);
    this._getConcreteNumberTrivia = concrete;
    this._getRandomNumberTrivia = random;

    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter!.stringToUnsignedInteger(event.numberString);
        inputEither.fold(
          (l) {
            emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
          },
          (r) async {
            emit(Loading());
            final failureOrTrivia = await _getConcreteNumberTrivia!.call(
              params: Params(number: r),
            );
            _ethierLoadedOrFailureState(failureOrTrivia: failureOrTrivia);

            //OR
            // _getConcreteNumberTrivia!
            //     .call(params: Params(number: r))
            //     ?.then((failureOrTrivia) {
            //   if (failureOrTrivia != null) {
            //     failureOrTrivia.fold(
            //       (l) => throw UnimplementedError(),
            //       (r) => emit(Loaded(r)),
            //     );
            //   }
            // });
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final failureOrTrivia = await _getRandomNumberTrivia!.call(
          params: NoParams(),
        );
        _ethierLoadedOrFailureState(failureOrTrivia: failureOrTrivia);
      }
    });
  }

  void _ethierLoadedOrFailureState({
    Either<Failures, NumberTrivia>? failureOrTrivia,
  }) {
    if (failureOrTrivia != null) {
      failureOrTrivia.fold(
        (l) => emit(Error(message: _mapFailureToMessage(l))),
        (r) => emit(Loaded(r)),
      );
    }
  }

  String _mapFailureToMessage(Failures failures) {
    switch (failures.runtimeType) {
      case ServerFailures:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailures:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error";
    }
  }
}
