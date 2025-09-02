// lib/features/auth/domain/usecases/register_empresa_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/features/auth/domain/entities/empresa_entity.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';

class RegisterEmpresaUseCase {
  final AuthRepository repository;

  RegisterEmpresaUseCase(this.repository);

  Future<Either<Failure, EmpresaEntity>> call(RegisterEmpresaParams params) async {
    // Validações básicas
    if (params.nome.isEmpty || params.nome.length < 2) {
      return Left(ValidationFailure('Nome da empresa deve ter pelo menos 2 caracteres'));
    }

    if (params.username.isEmpty || params.username.length < 3) {
      return Left(ValidationFailure('Nome de usuário deve ter pelo menos 3 caracteres'));
    }

    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(params.username)) {
      return Left(ValidationFailure('Nome de usuário deve começar com letra e conter apenas letras, números e underscore'));
    }

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(params.email)) {
      return Left(ValidationFailure('Email inválido'));
    }

    if (params.password.length < 6) {
      return Left(ValidationFailure('Senha deve ter pelo menos 6 caracteres'));
    }

    return await repository.registerEmpresa(
      nome: params.nome,
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterEmpresaParams {
  final String nome;
  final String username;
  final String email;
  final String password;

  RegisterEmpresaParams({
    required this.nome,
    required this.username,
    required this.email,
    required this.password,
  });
}