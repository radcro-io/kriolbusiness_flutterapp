import 'package:gotrue/src/types/user.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.authUserId,
    required super.email,
    required super.nome,
    required super.username,
    super.pais,
    super.telefone,
  }) : super();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      authUserId: json['authUserId'],
      email: json['email'],
      nome: json['nome'],
      username: json['username'],
      pais: json['pais'],
      telefone: json['telefone'],
    );
  }

  @override
  Map<String, String?> toJson() {
    return {
      'authUserId': authUserId,
      'email': email,
      'nome': nome,
      'username': username,
      'pais': pais,
      'telefone': telefone,
    };
  }

  static UserModel fromSupabaseUser(User user) {
    return UserModel(
      authUserId: user.id,
      email: user.email ?? '',
      nome: user.userMetadata?['nome'] ?? '',
      username: user.userMetadata?['username'] ?? '',
      pais: user.userMetadata?['pais'],
      telefone: user.userMetadata?['telefone'],
    );
  }

}