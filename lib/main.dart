// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriolbusiness/config/setup/supabase_config.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/presentation_auth_bloc.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/presentation_auth_event.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/presentation_auth_state.dart';
import 'package:kriolbusiness/features/auth/presentation/pages/presentation_auth_page.dart';
import 'package:kriolbusiness/injection_container.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Supabase
  await SupabaseConfig.initialize();
  
  // Configurar injeção de dependências
  await setupDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KriolBusiness',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: BlocProvider(
        create: (context) => getIt<AuthBloc>()..add(CheckAuthRequested()),
        child: const AuthWrapper(),
      ),
    );
  }
}

/// Widget que gerencia a navegação baseada no estado de autenticação
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          // Usuário logado - mostrar tela principal
          return const HomePage();
        } else {
          // Usuário não logado - mostrar tela de autenticação
          return const AuthPage();
        }
      },
    );
  }
}

/// Tela principal (placeholder)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KriolBusiness'),
        backgroundColor: const Color(0xFF1B365D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Login realizado com sucesso!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bem-vindo, ${state.user.name ?? state.user.email}!',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB91C1C),
                    ),
                    child: const Text(
                      'Fazer Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

