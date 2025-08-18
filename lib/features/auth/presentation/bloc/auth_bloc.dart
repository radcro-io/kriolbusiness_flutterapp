// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriolbusiness/core/error/auth_failures.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/login_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/register_with_email_password_usecase.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/auth_event.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/auth_state.dart';



class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterWithEmailPasswordUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    LoginParams params = LoginParams(
      email: event.email,
      password: event.password,
    );

    final result = await loginUseCase(params);

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure as AuthFailure))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure as AuthFailure))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    await logoutUseCase();
    emit(AuthUnauthenticated());

  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure as AuthFailure))),
      (user) {
        emit(AuthAuthenticated(user: user));
            },
    );
  }

  String _mapFailureToMessage(AuthFailure failure) {
    switch (failure.runtimeType) {
      case AuthFailure:
        return 'Erro no servidor. Tente novamente mais tarde.';
      case InvalidCredentialsFailure:
        return 'Email ou senha inválidos.';
      case UserNotFoundFailure:
        return 'Usuário não encontrado.';
      case EmailAlreadyInUseFailure:
        return 'Este email já está em uso.';
      case WeakPasswordFailure:
        return 'A senha deve ter pelo menos 6 caracteres.';
      default:
        return 'Erro desconhecido. Tente novamente.';
    }
  }
}