import 'dart:io';
import 'package:kriolbusiness/features/auth/data/models/empresa_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:kriolbusiness/features/auth/data/models/user_model.dart';
import 'package:kriolbusiness/core/error/exceptions.dart';

/// Contrato do data source remoto para autenticação
abstract class AuthRemoteDataSource {
  /// Registra um novo usuário com email e senha
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
  });

  // Novos métodos para empresa
  Future<EmpresaModel> registerEmpresa({
    required String nome,
    required String username,
    required String email,
    required String password,
  });


  /// Faz login com email e senha
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Faz logout do usuário atual
  Future<void> signOut();

  /// Obtém o usuário atualmente logado
  Future<UserModel?> getCurrentUser();

  Future<bool> isUsernameAvailable(String username);
}

/// Implementação do data source remoto usando Supabase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String username,
  }) async {
    try {
      // Preparar metadata do usuário
      Map<String, dynamic>? userData;
      if (name.isNotEmpty) {
        userData = {
          'full_name': name,
          'name': name,
        };
      }

      // Fazer registro no Supabase
      final AuthResponse response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: userData,
      );

      // Verificar se o usuário foi criado
      if (response.user == null) {
        throw const AuthException('Falha ao registrar usuário', 'registration_failed');
      }

      var userModel = UserModel.fromSupabaseUser(response.user!);

      //prinnt userModel.toString();
      print('User registered: ${userModel.toString()}');

      //criar registro na tabela profiles
      final clientData = {
        'auth_user_id': userModel.authUserId,
        'email': email,
        'nome': name,
        'username': username,
      };

      final _ = await supabaseClient
          .from('cliente')
          .insert(clientData)
          .select()
          .single();

      // Retornar modelo do usuário
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      // Re-mapear exceções específicas do Supabase
      throw _mapSupabaseAuthException(e);
    } on SocketException {
      throw const NetworkException('Sem conexão com a internet');
    } on FormatException catch (e) {
      throw ServerException('Erro de formato de dados: ${e.message}');
    } catch (e) {
      throw ServerException('Erro no servidor durante registro: ${e.toString()}');
    }
  }

  @override
  Future<EmpresaModel> registerEmpresa({
    required String nome,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Verificar se username está disponível
      final isAvailable = await isUsernameAvailable(username);
      if (!isAvailable) {
        throw ServerException('Nome de usuário já está em uso');
      }

      // 2. Registrar no Supabase Auth
      final authResponse = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': nome,
          'username': username,
        },
      );

      if (authResponse.user == null) {
        throw ServerException('Falha ao criar conta');
      }

      final user = authResponse.user!;

      // 3. Criar registro na tabela empresas
      final empresaModel = EmpresaModel.forRegistration(
        authUserId: user.id,
        nome: nome,
        username: username,
        email: email,
      );

      final empresaData = await supabaseClient
          .from('empresas')
          .insert(empresaModel.toEmpresaInsertMap())
          .select()
          .single();

      // 4. Retornar modelo completo
      return EmpresaModel.fromSupabaseData(
        userData: {
          'id': user.id,
          'email': user.email,
          'user_metadata': user.userMetadata,
        },
        empresaData: empresaData,
      );
    } on AuthException catch (e) {
      throw ServerException(_mapAuthError(e.message));
    } on PostgrestException catch (e) {
      if (e.code == '23505') { // Unique constraint violation
        throw ServerException('Nome de usuário já está em uso');
      }
      throw ServerException('Erro no servidor: ${e.message}');
    } catch (e) {
      throw ServerException('Erro inesperado: $e');
    }
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    try {
      // Verificar em ambas as tabelas (clientes e empresas)
      final clienteResult = await supabaseClient
          .from('clientes')
          .select('username')
          .eq('username', username)
          .maybeSingle();

      if (clienteResult != null) return false;

      final empresaResult = await supabaseClient
          .from('empresas')
          .select('username')
          .eq('username', username)
          .maybeSingle();

      return empresaResult == null;
    } catch (e) {
      throw ServerException('Erro ao verificar disponibilidade do username');
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Fazer login no Supabase
      final AuthResponse response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Verificar se o login foi bem-sucedido
      if (response.user == null) {
        throw const AuthException('Credenciais inválidas', 'invalid_credentials');
      }

      // Retornar modelo do usuário
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      // Re-mapear exceções específicas do Supabase
      throw _mapSupabaseAuthException(e);
    } on SocketException {
      throw const NetworkException('Sem conexão com a internet');
    } on FormatException catch (e) {
      throw ServerException('Erro de formato de dados: ${e.message}');
    } catch (e) {
      throw ServerException('Erro no servidor durante login: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } on SocketException {
      throw const NetworkException('Sem conexão com a internet');
    } catch (e) {
      throw ServerException('Erro no servidor durante logout: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final User? user = supabaseClient.auth.currentUser;
      
      if (user == null) {
        return null;
      }

      // Verificar se a sessão ainda é válida
      final Session? session = supabaseClient.auth.currentSession;
      if (session == null || session.isExpired) {
        return null;
      }

      return UserModel.fromSupabaseUser(user);
    } on SocketException {
      throw const NetworkException('Sem conexão com a internet');
    } catch (e) {
      throw ServerException('Erro ao obter usuário atual: ${e.toString()}');
    }
  }

  /// Mapeia exceções do Supabase para exceções específicas da aplicação
  AuthException _mapSupabaseAuthException(AuthException e) {
    final message = e.message.toLowerCase();
    final code = e.code?.toLowerCase();

    // Mapear por código primeiro (mais confiável)
    if (code != null) {
      switch (code) {
        case 'invalid_credentials':
        case 'email_not_confirmed':
          return const AuthException('Email ou senha inválidos', 'invalid_credentials');
        case 'signup_disabled':
          return const AuthException('Registro desabilitado', 'signup_disabled');
        case 'email_address_invalid':
          return const AuthException('Email inválido', 'invalid_email');
        case 'password_too_short':
          return const AuthException('Senha muito curta', 'weak_password');
        case 'user_already_registered':
          return const AuthException('Email já está em uso', 'email_already_in_use');
        case 'user_not_found':
          return const AuthException('Usuário não encontrado', 'user_not_found');
        case 'email_not_confirmed':
          return const AuthException('Email não confirmado', 'email_not_confirmed');
        case 'too_many_requests':
          return const AuthException('Muitas tentativas. Tente novamente mais tarde', 'too_many_requests');
      }
    }

    // Mapear por mensagem (fallback)
    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password') ||
        message.contains('email not confirmed')) {
      return const AuthException('Email ou senha inválidos', 'invalid_credentials');
    } else if (message.contains('user already registered') ||
               message.contains('email already registered') ||
               message.contains('user with this email already exists')) {
      return const AuthException('Este email já está em uso', 'email_already_in_use');
    } else if (message.contains('password should be at least') ||
               message.contains('password is too short')) {
      return const AuthException('Senha deve ter pelo menos 6 caracteres', 'weak_password');
    } else if (message.contains('user not found')) {
      return const AuthException('Usuário não encontrado', 'user_not_found');
    } else if (message.contains('email not confirmed')) {
      return const AuthException('Email não confirmado', 'email_not_confirmed');
    } else if (message.contains('too many requests')) {
      return const AuthException('Muitas tentativas. Tente novamente mais tarde', 'too_many_requests');
    } else if (message.contains('invalid email')) {
      return const AuthException('Email inválido', 'invalid_email');
    } else if (message.contains('signup disabled')) {
      return const AuthException('Registro desabilitado', 'signup_disabled');
    }

    // Retornar exceção original se não conseguir mapear
    return AuthException(e.message, e.code);
  }

  String _mapAuthError(String message) {
    if (message.contains('email')) {
      return 'Email já está em uso';
    } else if (message.contains('password')) {
      return 'Senha muito fraca';
    } else if (message.contains('network')) {
      return 'Erro de conexão';
    }
    return message;
  }


}

