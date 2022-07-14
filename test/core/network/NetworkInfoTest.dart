import 'package:flutter_tdd_clean_architecture/core/network/NetworkInfo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  NetworkInfoImpl? networkInfo;
  MockInternetConnectionChecker? mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker!);
  });

  group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection is true',
      () async {
        // arrange
        final tHasConnectionFuture = true;
        when(() => mockDataConnectionChecker?.hasConnection)
            .thenAnswer((_) async => tHasConnectionFuture);
        // act
        // NOTICE: We're NOT awaiting the result
        final result = await networkInfo?.isConnected!;
        // assert
        verify(() => mockDataConnectionChecker?.hasConnection);
        // Utilizing Dart's default referential equality.
        // Only references to the same object are equal.
        expect(result, tHasConnectionFuture);
      },
    );

    test(
      'should forward the call to DataConnectionChecker.hasConnection is false',
      () async {
        // arrange
        final tHasConnectionFuture = false;
        when(() => mockDataConnectionChecker?.hasConnection)
            .thenAnswer((_) async => tHasConnectionFuture);
        // act
        // NOTICE: We're NOT awaiting the result
        final result = await networkInfo?.isConnected!;
        // assert
        verify(() => mockDataConnectionChecker?.hasConnection);
        // Utilizing Dart's default referential equality.
        // Only references to the same object are equal.
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
