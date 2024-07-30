import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class FailureWithNoMessage extends Failure {
  FailureWithNoMessage();
}

class MultipleLoginException extends Failure {
  final String errorMessage;

  MultipleLoginException(this.errorMessage);
}

class FailureWithMessage extends Failure {
  final String errorMessage;
  FailureWithMessage(this.errorMessage);
}

class ServerFailure extends Failure {
  final String? errorMessage;
  ServerFailure({this.errorMessage});
}

class NetworkFailure extends Failure {}
