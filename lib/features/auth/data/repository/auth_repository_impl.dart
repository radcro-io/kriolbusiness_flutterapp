// lib/features/auth/data/repository/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:kriolbusiness/core/error/auth_failures.dart';
import 'package:kriolbusiness/core/error/exceptions.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';
import 'package:kriolbusiness/features/auth/domain/entities/cliente_entity.dart';
import 'package:kriolbusiness/features/auth/domain/entities/empresa_entity.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource, required Object localDataSource});

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    String? username,
  }) async {
    try {
      final userModel = await remoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        username: username,
      );
      return Right(userModel); // userModel já é um UserEntity pois UserModel estende UserEntity
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      if (userModel == null) {
        return Left(AuthFailure('No user currently signed in'));
      }
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClienteEntity>> createClienteProfile({
    required String authUserId,
    required String nome,
    required String username,
    required String email,
    String? telefone,
    String? pais,
    DateTime? dataNascimento,
  }) async {
    try {
      final clienteModel = await remoteDataSource.createClienteProfile(
        authUserId: authUserId,
        nome: nome,
        username: username,
        email: email,
        telefone: telefone,
        pais: pais,
        dataNascimento: dataNascimento,
      );
      return Right(clienteModel); // clienteModel já é um ClienteEntity
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final empresaModel = await remoteDataSource.createEmpresaProfile(
        authUserId: authUserId,
        nome: nome,
        username: username,
        email: email,
        telefone: telefone,
        pais: pais,
        endereco: endereco,
        latitude: latitude,
        longitude: longitude,
        idSubcategoria: idSubcategoria,
        descricao: descricao,
        informacoesAdicionais: informacoesAdicionais,
      );
      return Right(empresaModel); // empresaModel já é um EmpresaEntity
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClienteEntity>> getClienteProfile({required String authUserId}) async {
    try {
      final clienteModel = await remoteDataSource.getClienteProfile(authUserId: authUserId);
      return Right(clienteModel);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmpresaEntity>> getEmpresaProfile({required String authUserId}) async {
    try {
      final empresaModel = await remoteDataSource.getEmpresaProfile(authUserId: authUserId);
      return Right(empresaModel);
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() {
    // TODO: Implementar login com Google
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() {
    // TODO: Implementar login com Facebook
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithApple() {
    // TODO: Implementar login com Apple
    throw UnimplementedError();
  }
}