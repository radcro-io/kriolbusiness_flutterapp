// lib/features/auth/data/models/empresa_model.dart

import 'package:flutter/foundation.dart';
import 'package:kriolbusiness/features/auth/domain/entities/empresa_entity.dart';
import 'package:kriolbusiness/features/auth/data/models/user_model.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart'; // Importe UserModel

class EmpresaModel extends EmpresaEntity {
  const EmpresaModel({
    required super.id,
    required super.authUserId,
    required super.nome,
    required super.username,
    required super.email,
    super.telefone,
    super.pais,
    super.endereco,
    super.latitude,
    super.longitude,
    super.idSubcategoria,
    super.descricao,
    super.informacoesAdicionais,
    required super.createdAt,
    super.updatedAt,
    super.user, 
  });

  // Factory para criar uma instância de EmpresaModel a partir de um JSON
  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      id: json['id'] as String,
      authUserId: json['auth_user_id'] as String,
      nome: json['nome'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      telefone: json['telefone'] as String?,
      pais: json['pais'] as String?,
      endereco: json['endereco'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      idSubcategoria: json['id_subcategoria'] as String?,
      descricao: json['descricao'] as String?,
      informacoesAdicionais: json['informacoes_adicionais'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      user: UserModel.fromJson(json['user']),
    );
  }
  // Método para converter uma instância de EmpresaModel em um JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_user_id': authUserId,
      'nome': nome,
      'username': username,
      'email': email,
      'telefone': telefone,
      'pais': pais,
      'endereco': endereco,
      'latitude': latitude,
      'longitude': longitude,
      'id_subcategoria': idSubcategoria,
      'descricao': descricao,
      'informacoes_adicionais': informacoesAdicionais,
      'created_At': createdAt,
      'updated_At' : updatedAt,
      'user': user,
    };
  }
}