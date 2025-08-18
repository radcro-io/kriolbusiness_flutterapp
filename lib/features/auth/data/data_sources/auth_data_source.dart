import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kriolbusiness/features/auth/data/models/user_model.dart';
import 'package:kriolbusiness/core/error/exceptions.dart';


abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(cachedUserKey);
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        return UserModel.fromMap(jsonMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Erro ao recuperar usuário do cache: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = json.encode(user.toMap());
      await sharedPreferences.setString(cachedUserKey, jsonString);
    } catch (e) {
      throw CacheException('Erro ao salvar usuário no cache: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(cachedUserKey);
    } catch (e) {
      throw CacheException('Erro ao limpar cache: ${e.toString()}');
    }
  }
}