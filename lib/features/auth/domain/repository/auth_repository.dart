import 'package:dartz/dartz.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';
import 'package:kriolbusiness/features/auth/domain/entities/empresa_entity.dart';

abstract class AuthRepository {
  // Define os métodos que o repositório deve implementar
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
  });

   // Novos métodos para empresa
  Future<Either<Failure, EmpresaEntity>> registerEmpresa({
    required String nome,
    required String username,
    required String email,
    required String password,
  });


  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();
  // Verificação de username (comum para ambos)
  Future<Either<Failure, bool>> isUsernameAvailable(String username);
}