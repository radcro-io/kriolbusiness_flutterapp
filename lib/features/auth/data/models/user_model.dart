import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.username,
    super.emailConfirmedAt,
    required super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['full_name'] as String?,
      username: user.userMetadata?['username'] as String?,
      emailConfirmedAt: user.emailConfirmedAt,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String?,
      username: map['username'] as String?,
      emailConfirmedAt: map['email_confirmed_at'] as String?,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'email_confirmed_at': emailConfirmedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static UserModel fromJson(json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      username: json['username'] as String?,
      emailConfirmedAt: json['email_confirmed_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );
  }
}