import 'dart:convert';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/Exceptions.dart';

abstract class NumberTriviaLocalDataSource {
  /// https://blog.victoreronmosele.com/mocking-shared-preferences-flutter
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel>? getLastNumberTrivia();

  Future<void>? cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences? sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  static const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";

  @override
  Future<NumberTriviaModel>? getLastNumberTrivia() {
    final jsonString = sharedPreferences!.getString(CACHED_NUMBER_TRIVIA);
    Map<String, dynamic> jsonDecoder = Map();
    if (jsonString != null) {
      jsonDecoder = json.decode(jsonString);
      NumberTriviaModel model = NumberTriviaModel.fromJson(jsonDecoder);
      return Future.value(model);
    } else {
      throw CacheExceptions();
    }
  }

  // @override
  // Future<void>? cacheNumberTrivia(NumberTriviaModel numberTriviaModel) async {
  //   var jsonEncoderData = json.encode(numberTriviaModel);
  //   await sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonEncoderData);
  //   return Future.value();
  // }

  @override
  Future<void>? cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    sharedPreferences!.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(triviaToCache.toJson()),
    );

    return Future.value();
  }
}
