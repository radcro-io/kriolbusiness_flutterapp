// lib/config/supabase_config.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuração do Supabase
class SupabaseConfig {
  /// URLs e chaves do projeto Supabase
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Inicializa o Supabase
  static Future<void> initialize() async {
    try {
      // Carregar variáveis de ambiente
      await dotenv.load(fileName: ".env");

      // Validar configurações
      if (supabaseUrl.isEmpty) {
        throw Exception('SUPABASE_URL não configurada no arquivo .env');
      }
      if (supabaseAnonKey.isEmpty) {
        throw Exception('SUPABASE_ANON_KEY não configurada no arquivo .env');
      }

      // Inicializar Supabase
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          autoRefreshToken: true,
        ),
      );

      print('✅ Supabase inicializado com sucesso');
    } catch (e) {
      print('❌ Erro ao inicializar Supabase: $e');
      rethrow;
    }
  }

  /// Obtém o cliente Supabase
  static SupabaseClient get client => Supabase.instance.client;

  /// Verifica se há usuário logado
  static bool get isLoggedIn => client.auth.currentUser != null;
}

