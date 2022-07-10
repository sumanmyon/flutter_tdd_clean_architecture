import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  List properties;

  Failures([
    this.properties = const <dynamic>[],
  ]);

  @override
  List<Object> get props => [properties];
}


//General Failures
class ServerFailures extends Failures {
}

class CacheFailures extends Failures {}