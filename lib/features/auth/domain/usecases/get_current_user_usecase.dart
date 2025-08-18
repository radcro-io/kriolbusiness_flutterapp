// lib/features/auth/domain/usecases/get_current_user_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.getCurrentUser();
  }
}