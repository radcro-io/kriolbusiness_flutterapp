import 'package:dartz/dartz.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/features/auth/domain/entities/cliente_entity.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';
import 'package:kriolbusiness/core/error/auth_failures.dart';

class CreateClienteProfileUseCase {
  final AuthRepository repository;

  CreateClienteProfileUseCase(this.repository);

  Future<Either<Failure, ClienteEntity>> call({
    required String authUserId,
    required String nome,
    required String username,
    required String email,
    String? telefone,
    String? pais,
    DateTime? dataNascimento,
  }) async {
    // Validações de domínio completas
    final validationResult = _validateInput(
      authUserId: authUserId,
      nome: nome,
      username: username,
      email: email,
      telefone: telefone,
      pais: pais,
      dataNascimento: dataNascimento,
    );
    if (validationResult != null) {
      return Left(validationResult);
    }

    return await repository.createClienteProfile(
      authUserId: authUserId,
      nome: nome,
      username: username,
      email: email,
      telefone: telefone,
      pais: pais,
      dataNascimento: dataNascimento,
    );
  }

  Failure? _validateInput({
    required String authUserId,
    required String nome,
    required String username,
    required String email,
    String? telefone,
    String? pais,
    DateTime? dataNascimento,
  }) {
    // Example validation logic, replace with your own rules
    if (authUserId.isEmpty) {
      return AuthFailure('authUserId cannot be empty');
    }
    if (nome.isEmpty) {
      return AuthFailure('nome cannot be empty');
    }
    if (username.isEmpty) {
      return AuthFailure('username cannot be empty');
    }
    if (email.isEmpty || !email.contains('@')) {
      return AuthFailure('Invalid email');
    }
    // Add more validations as needed
    return null;
  }
}