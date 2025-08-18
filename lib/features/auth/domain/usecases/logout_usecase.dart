// lib/features/auth/domain/usecases/logout_usecase.dart

import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.signOut();
  }
}