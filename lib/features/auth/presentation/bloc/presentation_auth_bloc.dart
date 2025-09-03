// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriolbusiness/core/error/auth_failures.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/is_username_available_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/register_empresa_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/register_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/login_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/presentation_auth_event.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/presentation_auth_state.dart';

/// BLoC para gerenciar o estado de autenticação
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final RegisterEmpresaUseCase registerEmpresaUseCase;
  final IsUsernameAvailableUseCase isUsernameAvailableUseCase;

  AuthBloc({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.registerEmpresaUseCase,
    required this.isUsernameAvailableUseCase,
  }) : super(AuthInitial()) {
    // Registrar handlers para cada evento
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthRequested>(_onCheckAuthRequested);
    on<RegisterEmpresaRequested>(_onRegisterEmpresaRequested);
    on<CheckUsernameAvailability>(_onCheckUsernameAvailability);
  }

Future<void> _onRegisterEmpresaRequested(
    RegisterEmpresaRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final params = RegisterEmpresaParams(
      nome: event.nome,
      username: event.username,
      email: event.email,
      password: event.password,
    );

    final result = await registerEmpresaUseCase(params);

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (empresa) => emit(EmpresaAuthenticated(empresa: empresa)),
    );
  }

  Future<void> _onCheckUsernameAvailability(
    CheckUsernameAvailability event,
    Emitter<AuthState> emit,
  ) async {
    final result = await isUsernameAvailableUseCase(event.username);
    
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (isAvailable) {
        if (isAvailable) {
          emit(UsernameAvailable(
            username: event.username,
            isAvailable: true,
          ));
        } else {
          emit(UsernameAvailable(
            username: event.username,
            isAvailable: false,
          ));
        }
      },
    );
  }
  /// Handler para evento de registro
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      name: event.nome,
      username: event.username,
    );
    print( 'Register result: $result'); // Log do resultado do registro
    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Handler para evento de login
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Handler para evento de logout
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  /// Handler para verificar autenticação atual
  Future<void> _onCheckAuthRequested(
    CheckAuthRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  /// Mapeia failures para mensagens amigáveis ao usuário
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Erro no servidor. Tente novamente mais tarde.';
      case NetworkFailure:
        return 'Erro de conexão. Verifique sua internet.';
      case InvalidCredentialsFailure:
        return 'Email ou senha inválidos.';
      case EmailAlreadyInUseFailure:
        return 'Este email já está em uso.';
      case WeakPasswordFailure:
        return 'A senha deve ter pelo menos 6 caracteres.';
      case UserNotFoundFailure:
        return 'Usuário não encontrado.';
      case EmailNotConfirmedFailure:
        return 'Email não confirmado. Verifique sua caixa de entrada.';
      case RequiredFieldFailure:
        return 'O campo é obrigatório.';
      case InvalidEmailFailure:
        return 'Email inválido.';
      case PasswordTooShortFailure:
        return 'Senha deve ter pelo menos 6 caracteres.';
      case ValidationFailure:
        return 'Erro de validação. Verifique os dados informados.';
      default:
        return 'Erro desconhecido. Tente novamente.';
    }
  }
}

