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
  final String name;
  final String username;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.username,
  });

  @override
  List<Object> get props => [email, password, name ?? ''];
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

