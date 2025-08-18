// lib/features/auth/domain/failures/auth_failure.dart

import 'package:equatable/equatable.dart';
import 'package:kriolbusiness/core/error/failures.dart';

class AuthFailure extends Failure {
  final String message;
  const AuthFailure([this.message = 'Erro de autenticação']);
  @override
  List<Object> get props => [message];
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure([super.message = 'Email ou senha inválidos']);
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure([super.message = 'Este email já está em uso']);
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure([super.message = 'A senha deve ter pelo menos 6 caracteres']);
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure([super.message = 'Usuário não encontrado']);
}
