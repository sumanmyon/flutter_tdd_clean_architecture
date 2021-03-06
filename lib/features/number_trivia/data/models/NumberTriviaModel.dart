import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({required int number, required String text})
      : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    // if (json == null) {
    //   return NumberTriviaModel(
    //     number: (json["number"] as num).toInt(),
    //     text: json["text"],
    //   );
    // } else {
    //   return NumberTriviaModel(
    //     text: "",
    //     number: -1,
    //   );
    // }
    return NumberTriviaModel(
      number: (json["number"] as num).toInt(),
      text: json["text"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "number": number,
      "text": text,
    };
  }
}
