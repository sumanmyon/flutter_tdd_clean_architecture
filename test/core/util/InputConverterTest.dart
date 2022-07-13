import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/util/InputConverter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter? inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("stringToUnsignedInteger", () {
    test(
      "should return an integer when represents an unsigned integer",
      () async {
        //arrange
        final str = "123";

        //act
        final result = inputConverter!.stringToUnsignedInteger(str);

        //assert
        expect(result, Right(123));
      },
    );

    test(
      "should return a Failures when string is not an integer",
          () async {
        //arrange
        final str = "1.0";

        //act
        final result = inputConverter!.stringToUnsignedInteger(str);

        //assert
        expect(result, Left(InvalidInputFaliure()));
      },
    );

    test(
      "should return a Failures when string is a negative integer",
          () async {
        //arrange
        final str = "-123";

        //act
        final result = inputConverter!.stringToUnsignedInteger(str);

        //assert
        expect(result, Left(InvalidInputFaliure()));
      },
    );
  });
}
