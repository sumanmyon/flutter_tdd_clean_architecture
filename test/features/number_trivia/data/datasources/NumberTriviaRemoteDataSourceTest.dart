import 'dart:convert';
import 'package:flutter_tdd_clean_architecture/core/error/Exceptions.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/NumberTriviaRemoteDataSource.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/models/NumberTriviaModel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/FixtureReader.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl? dataSource;
  MockHttpClient? mockHttpClient;

  final tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('Trivia.json')));

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient!);
  });

  void httpClientSccess200(Uri url, Map<String, String> header) {
    when(() => mockHttpClient?.get(url, headers: header)).thenAnswer(
      (realInvocation) async => http.Response(fixture('Trivia.json'), 200),
    );
  }

  void httpClientFailure404(Uri url, Map<String, String> header) {
    when(() => mockHttpClient?.get(url, headers: header)).thenAnswer(
      (realInvocation) async => http.Response("Something went wrong", 404),
    );
  }

  group("getConcreteNumberTrivia", () {
    var url = Uri.parse('http://numbersapi.com/${tNumber}');
    var header = {
      'Content-Type': 'application/json',
    };

    test(
      """should preform GET request on a URL with number being the endpoint 
      and with application/json header""",
      () async {
        //arrange
        httpClientSccess200(url, header);

        //act
        dataSource?.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockHttpClient?.get(url, headers: header));
      },
    );

    test(
      """should preform GET request on a URL with number being the endpoint 
      and with application/json header and response code is 200""",
      () async {
        //arrange
        httpClientSccess200(url, header);

        //act
        final result = await dataSource?.getConcreteNumberTrivia(tNumber);

        //assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      "should return a ServerExceptions when server code is 404 and others",
      () async {
        //arrange
        httpClientFailure404(url, header);

        //act
        final result = dataSource?.getConcreteNumberTrivia;

        //assert
        expect(() => result?.call(tNumber),
            throwsA(TypeMatcher<ServerExceptions>()));
      },
    );
  });

  group("getRandomNumberTrivia", () {
    var url = Uri.parse('http://numbersapi.com/random');
    var header = {
      'Content-Type': 'application/json',
    };

    test(
      """should preform GET request on a URL with number being the endpoint 
      and with application/json header""",
      () async {
        //arrange
        httpClientSccess200(url, header);

        //act
        dataSource?.getRandomNumberTrivia();

        //assert
        verify(() => mockHttpClient?.get(url, headers: header));
      },
    );

    test(
      """should preform GET request on a URL with number being the endpoint 
      and with application/json header and response code is 200""",
      () async {
        //arrange
        httpClientSccess200(url, header);

        //act
        final result = await dataSource?.getRandomNumberTrivia();

        //assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      "should return a ServerExceptions when server code is 404 and others",
      () async {
        //arrange
        httpClientFailure404(url, header);

        //act
        final result = dataSource?.getRandomNumberTrivia;

        //assert
        expect(() => result?.call(), throwsA(TypeMatcher<ServerExceptions>()));
      },
    );
  });
}
