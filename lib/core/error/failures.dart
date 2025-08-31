import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}


class NetworkFailure extends Failure {
  final String message;
  const NetworkFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  final String message;
  const ServerFailure(this.message);

  @override
  List<Object> get props => [message];
}

class UnknownFailure extends Failure {
  final String message;
  const UnknownFailure(this.message);

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  final String message;
  const CacheFailure(this.message);

  @override
  List<Object> get props => [message];
}

class RequiredFieldFailure extends Failure {
  final String message;
  const RequiredFieldFailure(this.message);

  @override
  List<Object> get props => [message];
}

class InvalidEmailFailure extends Failure {
  final String message;
  const InvalidEmailFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ShortPasswordFailure extends Failure {
  final String message;
  const ShortPasswordFailure(this.message);

  @override
  List<Object> get props => [message];
}

class PasswordTooShortFailure extends Failure {
  final String message;
  const PasswordTooShortFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ValidationFailure extends Failure {
  final String message;
  const ValidationFailure(this.message);

  @override
  List<Object> get props => [message];
}