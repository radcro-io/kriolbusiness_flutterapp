// lib/features/auth/presentation/bloc/auth_state.dart

import 'package:equatable/equatable.dart';
import 'package:kriolbusiness/features/auth/domain/entities/empresa_entity.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';

/// Estados do BLoC de autenticação
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitial extends AuthState {}

/// Estado de carregamento
class AuthLoading extends AuthState {}

/// Estado quando usuário está autenticado
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

/// Estado quando usuário não está autenticado
class AuthUnauthenticated extends AuthState {}

/// Estado de erro
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Estado de empresa autenticada
class EmpresaAuthenticated extends AuthState {
  final EmpresaEntity empresa;

  const EmpresaAuthenticated({required this.empresa});

  @override
  List<Object> get props => [empresa];
}

/// Estado de verificação de username
class UsernameAvailabilityChecked extends AuthState {
  final String username;
  final bool isAvailable;

  const UsernameAvailabilityChecked({
    required this.username,
    required this.isAvailable,
  });

  @override
  List<Object> get props => [username, isAvailable];
}