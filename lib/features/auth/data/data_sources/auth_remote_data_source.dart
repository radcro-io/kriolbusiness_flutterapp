import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kriolbusiness/core/error/exceptions.dart';
import 'package:kriolbusiness/features/auth/data/models/user_model.dart';
import 'package:kriolbusiness/features/auth/data/models/cliente_model.dart';
import 'package:kriolbusiness/features/auth/data/models/empresa_model.dart';
import 'package:kriolbusiness/core/error/auth_failures.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    String? username,
  });

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
  Future<UserModel?> getCurrentUser();

  // Métodos para perfis
  Future<ClienteModel> createClienteProfile({
    required String authUserId,
    required String nome,
    required String username,
    required String email,
    String? telefone,
    String? pais,
    DateTime? dataNascimento,
  });

  Future<EmpresaModel> createEmpresaProfile({
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

  Future<ClienteModel> getClienteProfile({required String authUserId});
  Future<EmpresaModel> getEmpresaProfile({required String authUserId});

  // Login social
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithFacebook();
  Future<UserModel> signInWithApple();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
    String? username,
  }) async {
    try {
      final AuthResponse response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          if (name != null) 'full_name': name,
          if (username != null) 'username': username,
        },
      );

      if (response.user == null) {
        throw const AuthFailure('Falha no registro do usuário');
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on AuthFailure catch (e) {
      throw _mapSupabaseAuthException(e);
    } on SocketException {
      throw const NetworkException('Sem conexão com a internet');
    } catch (e) {
      throw ServerException('Erro no servidor: ${e.toString()}');
    }
  }

  // Implementações dos outros métodos...
  
  AuthFailure _mapSupabaseAuthException(AuthFailure e) {
    final message = e.message.toLowerCase();
    
    if (message.contains('invalid login credentials')) {
      return const AuthFailure('Email ou senha inválidos');
    } else if (message.contains('email already registered')) {
      return const AuthFailure('Este email já está em uso');
    }
    // ... outros mapeamentos
    
    return AuthFailure(e.message);
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const AuthFailure('Falha no login do usuário');
      }

      return UserModel.fromSupabaseUser(response.user!);
    } on AuthFailure catch (e) {
      throw _mapSupabaseAuthException(e);
    } on SocketException {
      throw const NetworkException('Sem conexão com a internet');
    } catch (e) {
      throw ServerException('Erro no servidor: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthFailure catch (e) {
      throw _mapSupabaseAuthException(e);
    } on SocketException {
      throw const NetworkException('Sem conexão com a internet');
    } catch (e) {
      throw ServerException('Erro no servidor: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        return null;
      }
      return UserModel.fromSupabaseUser(user);
    } on AuthFailure catch (e) {
      throw _mapSupabaseAuthException(e);
    } on SocketException {
      throw const NetworkException('Sem conexão com a internet');
    } catch (e) {
      throw ServerException('Erro no servidor: ${e.toString()}');
    }
  }
  
  @override
  Future<ClienteModel> createClienteProfile({required String authUserId, required String nome, required String username, required String email, String? telefone, String? pais, DateTime? dataNascimento}) {
    // TODO: implement createClienteProfile
    throw UnimplementedError();
  }
  
  @override
  Future<EmpresaModel> createEmpresaProfile({required String authUserId, required String nome, required String username, required String email, String? telefone, String? pais, String? endereco, double? latitude, double? longitude, String? idSubcategoria, String? descricao, String? informacoesAdicionais}) {
    // TODO: implement createEmpresaProfile
    throw UnimplementedError();
  }
  
  @override
  Future<ClienteModel> getClienteProfile({required String authUserId}) {
    // TODO: implement getClienteProfile
    throw UnimplementedError();
  }
  
  @override
  Future<EmpresaModel> getEmpresaProfile({required String authUserId}) {
    // TODO: implement getEmpresaProfile
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel> signInWithApple() {
    // TODO: implement signInWithApple
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }
}