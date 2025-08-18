import 'package:flutter/material.dart';
import 'package:kriolbusiness/features/auth/presentation/pages/auth_page.dart'; // Importe sua AuthPage
import 'package:kriolbusiness/config/theme/app_colors.dart'; // Importe a classe AppColors centralizada
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Importações das camadas Data e Domain
import 'package:kriolbusiness/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:kriolbusiness/features/auth/data/repository/auth_repository_impl.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/login_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/register_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/logout_usecase.dart';
import 'package:kriolbusiness/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/auth_bloc.dart';


final GetIt sl = GetIt.instance; // 'sl' é uma convenção para Service Locator

Future<void> setupLocator() async {
  // Supabase Client
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL', // Substitua pela sua URL do Supabase
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Substitua pela sua chave anon do Supabase
  );
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Data Layer
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Domain Layer
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Presentation Layer (Bloc)
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar o localizador de serviços
  await setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KriolBusiness',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Pode ser ajustado para uma cor da sua paleta se desejar
        fontFamily: 'Roboto', // Define Roboto como a fonte padrão para todo o aplicativo
        scaffoldBackgroundColor: AppColors.prussianBlue, // Fundo padrão para Scaffold
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.prussianBlue,
          foregroundColor: AppColors.papayaWhip,
          elevation: 0,
        ),
        textTheme: TextTheme(
          // Estilos de texto padrão usando Roboto e cores da paleta
          displayLarge: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          displayMedium: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          displaySmall: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          headlineLarge: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          headlineMedium: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          headlineSmall: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          titleLarge: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          titleMedium: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          titleSmall: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          bodyLarge: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          bodyMedium: TextStyle(color: AppColors.airSuperiorityBlue, fontFamily: 'Roboto'),
          bodySmall: TextStyle(color: AppColors.airSuperiorityBlue, fontFamily: 'Roboto'),
          labelLarge: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          labelMedium: TextStyle(color: AppColors.airSuperiorityBlue, fontFamily: 'Roboto'),
          labelSmall: TextStyle(color: AppColors.airSuperiorityBlue, fontFamily: 'Roboto'),
        ),
        // Adicione outras configurações de tema conforme necessário, usando as cores da sua paleta
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.prussianBlue.withOpacity(0.5),
            labelStyle: TextStyle(color: AppColors.airSuperiorityBlue),
            hintStyle: TextStyle(color: AppColors.airSuperiorityBlue.withOpacity(0.7)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColors.airSuperiorityBlue.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColors.airSuperiorityBlue.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppColors.fireBrick),
            ),
          ),
      ),
      home: const AuthPage(), // Define AuthPage como a tela inicial
    );
  }
}
