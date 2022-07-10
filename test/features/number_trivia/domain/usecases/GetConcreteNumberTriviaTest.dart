import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/NumberTrivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/NumberTriviaRepository.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository!);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(
    text: "abc",
    number: 1,
  );

  test("Should get trivia for the number from the repository", () async {
    //arrange
    when(mockNumberTriviaRepository!.getConcreteNumberTrivia(1))
        .thenAnswer((_) async => Right(tNumberTrivia));

    //act
    final result = await usecase!(params: Params(number: tNumber));
    //final result = await usecase!.call(number: tNumber);

    //assets
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository!.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
