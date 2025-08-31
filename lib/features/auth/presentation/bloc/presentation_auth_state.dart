// lib/features/auth/presentation/bloc/auth_state.dart

import 'package:equatable/equatable.dart';
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

