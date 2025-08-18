import 'package:dartz/dartz.dart';
import 'package:kriolbusiness/core/error/auth_failures.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';

class RegisterWithEmailPasswordUseCase {
  final AuthRepository repository;

  RegisterWithEmailPasswordUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    String? name,
    String? username,
  }) async {
    // Validações de domínio
    final validationResult = _validateInput(email, password, name, username);
    if (validationResult != null) {
      return Left(validationResult);
    }

    return await repository.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      username: username,
    );
  }

  Failure? _validateInput(String email, String password, String? name, String? username) {
    // Validar email
    if (email.isEmpty) {
      return const AuthFailure('Email');
    }
    if (!_isValidEmail(email)) {
      return const AuthFailure('exemplo@dominio.com');
    }

    // Validar senha
    if (password.isEmpty) {
      return const AuthFailure('Senha');
    }
    if (password.length < 6) {
      return const AuthFailure('Senha');
    }
    if (password.length > 128) {
      return const AuthFailure('Senha');
    }

    // Validar nome (se fornecido)
    if (name != null && name.isNotEmpty) {
      if (name.length < 2) {
        return const AuthFailure('Nome');
      }
      if (name.length > 100) {
        return const AuthFailure('Nome');
      }
    }

    // Validar username (se fornecido)
    if (username != null && username.isNotEmpty) {
      if (username.length < 3) {
        return const AuthFailure('Nome de usuário');
      }
      if (username.length > 30) {
        return const AuthFailure('Nome de usuário');
      }
      if (!_isValidUsername(username)) {
        return const AuthFailure('apenas letras, números e underscore');
      }
    }

    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  bool _isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username);
  }
}