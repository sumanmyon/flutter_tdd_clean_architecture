import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/error/Failures.dart';
import 'package:flutter_tdd_clean_architecture/core/usecases/Usecase.dart';
import 'package:flutter_tdd_clean_architecture/core/util/InputConverter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/GetRandomNumberTrivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConvertor extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc? bloc;
  MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia? mockGetRandomNumberTrivia;
  MockInputConvertor? mockInputConvertor;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConvertor = MockInputConvertor();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConvertor,
    );
  });

  test("initial state should be empty", () async {
    //assert
    expect(bloc!.state, Empty());
  });

  group("GetConcreteNumberTrivia", () {
    final tNumberString = "1";
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(
      text: "Test text",
      number: 1,
    );

    void setUpMockInputConverterSuccess() {
      when(() => mockInputConvertor?.stringToUnsignedInteger(any()))
          .thenReturn(Right(tNumberParsed));
    }

    test(
      "should call a input converter to validate and convert string to an unsigned integer",
      () async {
        //arrange
        setUpMockInputConverterSuccess();

        //act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
          () => mockInputConvertor?.stringToUnsignedInteger(any()),
        ); //await and help to test async functions

        //asset
        verify(
            () => mockInputConvertor!.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        //For stream arrange, asset, act
        //arrange
        when(() => mockInputConvertor?.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFaliure()));

        //asset
        var expected = [
          //Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(
          bloc!.stream,
          emitsInOrder(expected),
        );

        //act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        //arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia!(params: any(named: "params")))
            .thenAnswer((_) async => Right(tNumberTrivia));

        //act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
            () => mockGetConcreteNumberTrivia!(params: any(named: "params")));

        //asset
        verify(() => mockGetConcreteNumberTrivia!
            .call(params: Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data got successfully',
      () async {
        //For stream arrange, asset, act
        //arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia!(params: any(named: "params")))
            .thenAnswer((_) async => Right(tNumberTrivia));

        //asset
        var expected = [
          //Empty(),
          Loading(),
          Loaded(tNumberTrivia),
        ];
        expectLater(bloc!.stream, emitsInOrder(expected));

        //act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when data got fails',
      () async {
        //For stream arrange, asset, act
        //arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia!(params: any(named: "params")))
            .thenAnswer((_) async => Left(ServerFailures()));

        //asset
        var expected = [
          //Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc!.stream, emitsInOrder(expected));

        //act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when data got fails from cache',
      () async {
        //For stream arrange, asset, act
        //arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia!(params: any(named: "params")))
            .thenAnswer((_) async => Left(CacheFailures()));

        //asset
        var expected = [
          //Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc!.stream, emitsInOrder(expected));

        //act
        bloc!.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group("GetRandomNumberTrivia", () {
    final tNumberTrivia = NumberTrivia(
      text: "Test text",
      number: 1,
    );

    test(
      'should get data from the random use case',
      () async {
        //arrange
        when(() => mockGetRandomNumberTrivia!(params: any(named: "params")))
            .thenAnswer((_) async => Right(tNumberTrivia));

        //act
        bloc!.add(GetTriviaForRandomNumber());
        await untilCalled(
            () => mockGetRandomNumberTrivia!(params: any(named: "params")));

        //asset
        verify(() => mockGetRandomNumberTrivia!.call(params: NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data got successfully',
      () async {
        //For stream arrange, asset, act
        //arrange
        when(() => mockGetRandomNumberTrivia!(params: any(named: "params")))
            .thenAnswer((_) async => Right(tNumberTrivia));

        //asset
        var expected = [
          //Empty(),
          Loading(),
          Loaded(tNumberTrivia),
        ];
        expectLater(bloc!.stream, emitsInOrder(expected));

        //act
        bloc!.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when data got fails from cache',
      () async {
        //For stream arrange, asset, act
        //arrange
        when(() => mockGetRandomNumberTrivia!(params: any(named: "params")))
            .thenAnswer((_) async => Left(CacheFailures()));

        //asset
        var expected = [
          //Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc!.stream, emitsInOrder(expected));

        //act
        bloc!.add(GetTriviaForRandomNumber());
      },
    );
  });
}
