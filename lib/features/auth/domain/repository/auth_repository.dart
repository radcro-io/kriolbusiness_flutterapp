// lib/features/auth/domain/repository/auth_repository.dart
import 'package:dartz/dartz.dart'; // Para Either
import 'package:kriolbusiness/core/error/failures.dart'; // Importe sua classe Failure
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';
import 'package:kriolbusiness/features/auth/domain/entities/cliente_entity.dart';
import 'package:kriolbusiness/features/auth/domain/entities/empresa_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    String? username,

    // Adicione outros campos de registro se necessário para Cliente/Empresa
  });

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  // Métodos para gerenciar perfis de cliente/empresa
  Future<Either<Failure, ClienteEntity>> createClienteProfile({
    required String authUserId,
    required String nome,
    required String username,
    required String email,
    String? telefone,
    String? pais,
    DateTime? dataNascimento,
  });

  Future<Either<Failure, EmpresaEntity>> createEmpresaProfile({
    required String authUserId,
    required String nome,
    required String username,
    required String email,
    String? telefone,
    String? pais,
    String? endereco,
    double? latitude,
    double? longitude,
    String? idSubcategoria,
    String? descricao,
    String? informacoesAdicionais,
  });

  Future<Either<Failure, ClienteEntity>> getClienteProfile({required String authUserId});
  Future<Either<Failure, EmpresaEntity>> getEmpresaProfile({required String authUserId});

  // Métodos para login social (assinaturas, implementação virá depois)
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, UserEntity>> signInWithFacebook();
  Future<Either<Failure, UserEntity>> signInWithApple();
}