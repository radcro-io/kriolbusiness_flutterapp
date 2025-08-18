import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kriolbusiness/features/auth/data/data_sources/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importações das camadas
import 'package:kriolbusiness/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:kriolbusiness/features/auth/data/repository/auth_repository_impl.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';

// Use cases
import 'package:kriolbusiness/features/auth/domain/usecases/register_with_email_password_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/create_cliente_profile_usecase.dart';

// BLoC
import 'package:kriolbusiness/features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

extension on GetIt {
  void init() {}
}

Future<void> setupDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => RegisterWithEmailPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => CreateClienteProfileUseCase(getIt()));

  // BLoCs
  getIt.registerFactory(
    () => AuthBloc(
      registerUseCase: getIt(),
      loginUseCase: getIt(),
      logoutUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
    ),
  );
}