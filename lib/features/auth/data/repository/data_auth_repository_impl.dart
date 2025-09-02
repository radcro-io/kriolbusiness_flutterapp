// lib/features/auth/data/repository/auth_repository_impl.dart

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:kriolbusiness/core/error/auth_failures.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/core/error/exceptions.dart';
import 'package:kriolbusiness/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:kriolbusiness/features/auth/data/data_sources/auth_local_datasource.dart';
import 'package:kriolbusiness/features/auth/domain/entities/empresa_entity.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';

/// Implementação do repositório de autenticação
/// Coordena entre data sources remoto e local
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
  }) async {
    try {
      final userModel = await remoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name, username: username,
       
      );

      // Cache do usuário localmente
      await localDataSource.cacheUser(userModel);

      return Right(userModel);
    } on AuthException catch (e) {
      return Left(_mapAuthExceptionToFailure(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(const NetworkFailure('Sem conexão com a internet'));
    } catch (e) {
      return Left(UnknownFailure('Erro inesperado: ${e.toString()}')); 
    }
  }

  @override
  Future<Either<Failure, EmpresaEntity>> registerEmpresa({
    required String nome,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final empresaModel = await remoteDataSource.registerEmpresa(
        nome: nome,
        username: username,
        email: email,
        password: password,
      );

      // Cache da empresa localmente
      await localDataSource.cacheEmpresa(empresaModel);

      return Right(empresaModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Erro inesperado: $e'));
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

      // Cache do usuário localmente
      await localDataSource.cacheUser(userModel);

      return Right(userModel);
    } on AuthException catch (e) {
      return Left(_mapAuthExceptionToFailure(e));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(const NetworkFailure('Sem conexão com a internet'));
    } catch (e) {
      return Left(UnknownFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearCache();
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on SocketException {
      return Left(const NetworkFailure('Sem conexão com a internet'));
    } catch (e) {
      return Left(UnknownFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      // Primeiro tenta obter do cache local
      try {
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        }
      } on CacheException {
        // Se falhar no cache, continua para buscar remotamente
      }

      // Se não há cache, busca remotamente
      final userModel = await remoteDataSource.getCurrentUser();

      if (userModel != null) {
        // Cache do usuário localmente
        await localDataSource.cacheUser(userModel);
        return Right(userModel);
      } else {
        return const Right(null);
      }
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(const NetworkFailure('Sem conexão com a internet'));
    } catch (e) {
      return Left(UnknownFailure('Erro inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isUsernameAvailable(String username) async {
    try {
      final isAvailable = await remoteDataSource.isUsernameAvailable(username);
      return Right(isAvailable);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Erro inesperado: $e'));
    }
  }

  /// Mapeia exceções de autenticação para failures
  AuthFailure _mapAuthExceptionToFailure(AuthException exception) {
    switch (exception.code) {
      case 'invalid_credentials':
        return const InvalidCredentialsFailure();
      case 'email_already_in_use':
        return const EmailAlreadyInUseFailure();
      case 'weak_password':
        return const WeakPasswordFailure();
      case 'user_not_found':
        return const UserNotFoundFailure();
      case 'email_not_confirmed':
        return const EmailNotConfirmedFailure();
      default:
        return AuthFailure(exception.message);
    }
  }
  
}





