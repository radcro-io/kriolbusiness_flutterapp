// lib/features/auth/domain/usecases/register_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/core/usecases/usecase.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.registerWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
      username: params.username,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String? name;
  final String? username;

  const RegisterParams({
    required this.email,
    required this.password,
    this.name,
    this.username,
  });

  @override
  List<Object?> get props => [email, password, name, username];
}