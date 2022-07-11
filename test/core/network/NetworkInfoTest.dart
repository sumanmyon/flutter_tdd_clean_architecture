import 'package:flutter_tdd_clean_architecture/core/network/NetworkInfo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {
  // @override
  // Future<bool> get hasConnection => Future.value(true);
}

void main() {
  NetworkInfoImpl? networkInfo;
  MockInternetConnectionChecker? mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker!);
  });

  group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      () async {
        // arrange
        final tHasConnectionFuture = Future.value(true);
        when(mockDataConnectionChecker?.hasConnection).thenAnswer((_) => tHasConnectionFuture);
        // act
        // NOTICE: We're NOT awaiting the result
        final result = networkInfo?.isConnected!;
        // assert
        verify(mockDataConnectionChecker?.hasConnection);
        // Utilizing Dart's default referential equality.
        // Only references to the same object are equal.
        expect(result, tHasConnectionFuture);
      },
    );
  });
}

// group("isConnected", () {
//   test(
//     "should forward call to InternetConnectionChecker.hasConnection",
//     () async {
//       when(mockInternetConnectionChecker?.hasConnection)
//           .thenAnswer((realInvocation) async => true);
//       final result = await networkInfoImpl?.isConnected;
//       verify(mockInternetConnectionChecker?.hasConnection);
//       expect(result, true);
//     },
//   );
// });
