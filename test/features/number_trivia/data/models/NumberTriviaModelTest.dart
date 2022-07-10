import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/FixtureReader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test("should be sub-class of NumberTrivia Entity", () async {
    //arrange
    //act
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test(
      "should return a valid model when the JSON number is an integer",
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture("Trivia.json"));

        //act
        final result = NumberTriviaModel.fromJson(jsonMap);

        //assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      "should return a valid model when the JSON number is regarded as double",
      () async {
        //arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture("TriviaDouble.json"));

        //act
        final result = NumberTriviaModel.fromJson(jsonMap);

        //assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group("toJson", () {
    test(
      "should return a JSON map containing a proper data",
      () async {
        //arrange
        //act
        final result = tNumberTriviaModel.toJson();

        //assert
        final expectedMap = {"text": "Test Text", "number": 1};
        expect(result, expectedMap);
      },
    );
  });
}
