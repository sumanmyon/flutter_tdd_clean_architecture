import 'package:flutter_tdd_clean_architecture/core/network/NetworkInfo.dart';
import 'package:flutter_tdd_clean_architecture/core/util/InputConverter.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/NumberTriviaLocalDataSource.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/datasources/NumberTriviaRemoteDataSource.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/data/repositories/NumberTriviaRepositoryImpl.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/repositories/NumberTriviaRepository.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/domain/usecases/GetRandomNumberTrivia.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /***
   *! Plugin Info: https://plugins.jetbrains.com/plugin/10850-better-comments
   ***/

  /***
   *! Features - Number Trivia
   ***/
  //Bloc- Do not use Singleton to register
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl.call(),
      random: sl.call(),
      inputConverter: sl.call(),
    ),
  );

  //Uses cases - it can be Singleton
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl.call()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl.call()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl.call(),
      localDataSource: sl.call(),
      networkInfo: sl.call(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl.call()),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl.call()),
  );

  /***
   *! Core
   ***/
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl.call()));

  /***
   *! External
   ***/
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
