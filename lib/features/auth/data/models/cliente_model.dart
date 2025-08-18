// lib/features/auth/data/models/cliente_model.dart
import 'package:kriolbusiness/features/auth/domain/entities/cliente_entity.dart';
import 'package:kriolbusiness/features/auth/data/models/user_model.dart'; // Importe UserModel

class ClienteModel extends ClienteEntity {
  const ClienteModel({
    required super.id,
    required super.authUserId,
    required super.nome,
    required super.email,
    required super.username,
    super.telefone,
    super.pais,
    super.dataNascimento,
    required super.createdAt, 
    super.updatedAt,
    super.user, 
  }) ;

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'] as String,
      authUserId: json['auth_user_id'] as String,
      nome: json['nome'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      telefone: json['telefone'] as String?,
      pais: json['pais'] as String?,
      dataNascimento: json['data_nascimento'] != null
          ? DateTime.parse(json['data_nascimento'] as String)
          : null,
      // authUser não é mapeado diretamente do JSON da tabela cliente, mas pode ser injetado
      // se os dados do auth.users forem buscados separadamente.
      user: null, // Ou UserModel.fromJson(json['auth_user']) se você fizer um join
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] != null
          ? json['updated_at'] as String
          : null, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_user_id': authUserId,
      'nome': nome,
      'username': username,
      'email': email,
      'telefone': telefone,
      'pais': pais,
      'data_nascimento': dataNascimento?.toIso8601String(),
      'user': user?.toJson(), // Se você tiver um usuário associado
    };
  }
}