// lib/features/auth/domain/usecases/login_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/core/usecases/usecase.dart'; // Você precisará criar esta classe base UseCase
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}