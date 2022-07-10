import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/core/usecases/Usecase.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/NumberTriviaRepository.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/GetRandomNumberTrivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository!);
  });

  final tNumberTrivia = NumberTrivia(
    text: "abc",
    number: 1,
  );

  test("Should get trivia with random number from the repository", () async {
    //arrange
    when(mockNumberTriviaRepository!.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    //act
    final result = await usecase!(params: NoParams());
    //final result = await usecase!.call(number: tNumber);

    //assets
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository!.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
