import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/Failures.dart';

class InputConverter {
  Either<Failures, int> stringToUnsignedInteger(String str) {
    try {
      final value = int.parse(str);
      if (value < 0) throw FormatException();
      return Right(value);
    } on FormatException {
      return Left(InvalidInputFaliure());
    }
  }
}

class InvalidInputFaliure extends Failures {}
