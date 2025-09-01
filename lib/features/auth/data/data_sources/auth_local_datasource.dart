// Auth Local Data Source
// lib/features/auth/data/data_sources/auth_local_datasource.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kriolbusiness/core/error/exceptions.dart';
import 'package:kriolbusiness/features/auth/data/models/user_model.dart';

/// Contrato do data source local para cache de autenticação
abstract class AuthLocalDataSource {
  /// Obtém o usuário em cache
  Future<UserModel?> getCachedUser();
  
  /// Salva o usuário no cache
  Future<void> cacheUser(UserModel user);
  
  /// Limpa o cache do usuário
  Future<void> clearCache();
  
  /// Verifica se há usuário em cache
  Future<bool> hasUserCached();
  
  /// Obtém informações básicas do cache (sem dados sensíveis)
  Future<Map<String, dynamic>?> getCacheInfo();
}

/// Implementação do data source local usando SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  // Chaves para o SharedPreferences
  static const String _cachedUserKey = 'CACHED_USER';
  static const String _cacheTimestampKey = 'CACHE_TIMESTAMP';
  static const String _cacheVersionKey = 'CACHE_VERSION';
  
  // Versão do cache (para invalidar cache antigo se necessário)
  static const int _currentCacheVersion = 1;
  
  // Tempo de expiração do cache (24 horas)
  static const Duration _cacheExpiration = Duration(hours: 24);

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      // Verificar se o cache é válido
      if (!await _isCacheValid()) {
        await clearCache();
        return null;
      }

      // Obter dados do usuário do cache
      final jsonString = sharedPreferences.getString(_cachedUserKey);
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }

      // Converter JSON para UserModel
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return UserModel.fromJson(jsonMap);
    } on FormatException catch (e) {
      // Cache corrompido - limpar e retornar null
      await clearCache();
      throw CacheException('Cache corrompido: ${e.message}');
    } catch (e) {
      throw CacheException('Erro ao recuperar usuário do cache: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      // Converter UserModel para JSON
      final jsonString = json.encode(user.toJson());
      // Salvar dados do usuário
      await sharedPreferences.setString(_cachedUserKey, jsonString);
      
      // Salvar timestamp do cache
      await sharedPreferences.setInt(
        _cacheTimestampKey, 
        DateTime.now().millisecondsSinceEpoch,
      );
      
      // Salvar versão do cache
      await sharedPreferences.setInt(_cacheVersionKey, _currentCacheVersion);
    } catch (e) {
      throw CacheException('Erro ao salvar usuário no cache: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      // Remover todos os dados relacionados ao cache de usuário
      await Future.wait([
        sharedPreferences.remove(_cachedUserKey),
        sharedPreferences.remove(_cacheTimestampKey),
        sharedPreferences.remove(_cacheVersionKey),
      ]);
    } catch (e) {
      throw CacheException('Erro ao limpar cache: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasUserCached() async {
    try {
      // Verificar se há dados no cache e se são válidos
      if (!await _isCacheValid()) {
        return false;
      }

      final jsonString = sharedPreferences.getString(_cachedUserKey);
      return jsonString != null && jsonString.isNotEmpty;
    } catch (e) {
      // Em caso de erro, assumir que não há cache válido
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getCacheInfo() async {
    try {
      final hasCache = await hasUserCached();
      if (!hasCache) {
        return null;
      }

      final timestamp = sharedPreferences.getInt(_cacheTimestampKey);
      final version = sharedPreferences.getInt(_cacheVersionKey);
      
      DateTime? cacheDate;
      if (timestamp != null) {
        cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      }

      return {
        'has_cache': hasCache,
        'cache_date': cacheDate?.toIso8601String(),
        'cache_version': version,
        'is_valid': await _isCacheValid(),
        'expires_at': cacheDate?.add(_cacheExpiration).toIso8601String(),
      };
    } catch (e) {
      return {
        'has_cache': false,
        'error': e.toString(),
      };
    }
  }

  /// Verifica se o cache é válido (não expirado e versão correta)
  Future<bool> _isCacheValid() async {
    try {
      // Verificar versão do cache
      final cacheVersion = sharedPreferences.getInt(_cacheVersionKey);
      if (cacheVersion == null || cacheVersion != _currentCacheVersion) {
        return false;
      }

      // Verificar se o cache não expirou
      final timestamp = sharedPreferences.getInt(_cacheTimestampKey);
      if (timestamp == null) {
        return false;
      }

      final cacheDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheDate);

      return difference < _cacheExpiration;
    } catch (e) {
      // Em caso de erro, considerar cache inválido
      return false;
    }
  }

  /// Força a expiração do cache (útil para testes ou logout forçado)
  Future<void> expireCache() async {
    try {
      // Define timestamp muito antigo para forçar expiração
      final expiredTimestamp = DateTime.now()
          .subtract(const Duration(days: 30))
          .millisecondsSinceEpoch;
      
      await sharedPreferences.setInt(_cacheTimestampKey, expiredTimestamp);
    } catch (e) {
      throw CacheException('Erro ao expirar cache: ${e.toString()}');
    }
  }

  /// Atualiza apenas o timestamp do cache (útil para refresh de sessão)
  Future<void> refreshCacheTimestamp() async {
    try {
      await sharedPreferences.setInt(
        _cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException('Erro ao atualizar timestamp do cache: ${e.toString()}');
    }
  }

  /// Migra cache de versões antigas (se necessário)
  Future<void> migrateCacheIfNeeded() async {
    try {
      final currentVersion = sharedPreferences.getInt(_cacheVersionKey);
      
      if (currentVersion == null) {
        // Primeira vez ou cache muito antigo - limpar tudo
        await clearCache();
        return;
      }

      if (currentVersion < _currentCacheVersion) {
        // Versão antiga - implementar migração se necessário
        // Por enquanto, apenas limpar o cache
        await clearCache();
      }
    } catch (e) {
      // Em caso de erro na migração, limpar cache
      await clearCache();
    }
  }
}

