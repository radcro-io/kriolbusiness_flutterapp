// TODO Implement this library.
//create usecase to login
//import 'package:dartz/dartz.dart';
import 'package:dartz/dartz.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';
/// Use case para login com email e senha
//register usecase
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
    required String username,
  }) async {
    return await repository.registerWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
      username: username,
    );
  }
}