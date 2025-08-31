// lib/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Data Sources
import 'package:kriolbusiness/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:kriolbusiness/features/auth/data/data_sources/auth_local_datasource.dart';
// Repository
import 'package:kriolbusiness/features/auth/data/repository/data_auth_repository_impl.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';

// Use Cases
import 'package:kriolbusiness/features/auth/domain/usecases/register_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/login_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/get_current_user_usecase.dart';

// BLoC
import 'package:kriolbusiness/features/auth/presentation/bloc/presentation_auth_bloc.dart';

final GetIt getIt = GetIt.instance;

/// Configura todas as dependências da aplicação
Future<void> setupDependencies() async {
  // ==========================================
  // DEPENDÊNCIAS EXTERNAS
  // ==========================================
  
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // SupabaseClient
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // ==========================================
  // DATA SOURCES
  // ==========================================
  
  // Remote Data Source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: getIt<SupabaseClient>(),
    ),
  );
  
  // Local Data Source
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  // ==========================================
  // REPOSITORY
  // ==========================================
  
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // ==========================================
  // USE CASES
  // ==========================================
  
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );
  
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );
  
  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<AuthRepository>()),
  );

  // ==========================================
  // BLOC
  // ==========================================
  
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      registerUseCase: getIt<RegisterUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );

  print('✅ Dependências configuradas com sucesso');
}

