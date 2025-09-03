// lib/features/auth/presentation/bloc/auth_event.dart

import 'package:equatable/equatable.dart';

/// Eventos do BLoC de autenticação
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object> get props => [];
}

/// Evento para registrar um novo usuário
class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String nome;
  final String username;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.nome,
    required this.username,
  });

  @override
  List<Object> get props => [email, password, nome ?? ''];
}

/// Evento para fazer login
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Evento para fazer logout
class LogoutRequested extends AuthEvent {}

/// Evento para verificar se há usuário logado
class CheckAuthRequested extends AuthEvent {}

/// Evento para registrar empresa
class RegisterEmpresaRequested extends AuthEvent {
  final String nome;
  final String username;
  final String email;
  final String password;

  const RegisterEmpresaRequested({
    required this.nome,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [nome, username, email, password];
}

/// Evento para verificar disponibilidade de username
class CheckUsernameAvailability extends AuthEvent {
  final String username;
  final bool isAvailable;

  const CheckUsernameAvailability({required this.username,
    required this.isAvailable,
  });

  @override
  List<Object> get props => [username, isAvailable];
}

