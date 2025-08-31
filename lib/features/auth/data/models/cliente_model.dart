// lib/features/auth/data/models/cliente_model.dart

import 'package:kriolbusiness/features/auth/domain/entities/cliente_entity.dart';

/// Modelo de dados do cliente
/// Estende a entidade e adiciona métodos de conversão para Supabase
/// Compatível com a estrutura da tabela 'clientes' no banco de dados
class ClienteModel extends ClienteEntity {
  const ClienteModel({
    required String id,
    required String authUserId,
    required String nome,
    required String username,
    required String email,
    String? telefone,
    String? pais,
    DateTime? dataNascimento,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
          id: id,
          authUserId: authUserId,
          nome: nome,
          username: username,
          email: email,
          telefone: telefone,
          pais: pais,
          dataNascimento: dataNascimento,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Cria um ClienteModel a partir de um Map (resposta do Supabase)
  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'] as String,
      authUserId: map['auth_user_id'] as String,
      nome: map['nome'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      telefone: map['telefone'] as String?,
      pais: map['pais'] as String?,
      dataNascimento: map['data_nascimento'] != null 
          ? DateTime.parse(map['data_nascimento'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Converte o ClienteModel para Map (para inserir/atualizar no Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'auth_user_id': authUserId,
      'nome': nome,
      'username': username,
      'email': email,
      'telefone': telefone,
      'pais': pais,
      'data_nascimento': dataNascimento?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt,
    };
  }

  /// Converte para Map para inserção (sem id, created_at, updated_at - gerados pelo banco)
  Map<String, dynamic> toInsertMap() {
    return {
      'auth_user_id': authUserId,
      'nome': nome,
      'username': username,
      'email': email,
      'telefone': telefone,
      'pais': pais,
      'data_nascimento': dataNascimento?.toIso8601String(),
    };
  }

  /// Converte para Map para atualização (apenas campos que podem ser alterados)
  Map<String, dynamic> toUpdateMap({
    String? nome,
    String? username,
    String? telefone,
    String? pais,
    DateTime? dataNascimento,
  }) {
    final updateData = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Adiciona apenas os campos que foram fornecidos
    if (nome != null) updateData['nome'] = nome;
    if (username != null) updateData['username'] = username;
    if (telefone != null) updateData['telefone'] = telefone;
    if (pais != null) updateData['pais'] = pais;
    if (dataNascimento != null) {
      updateData['data_nascimento'] = dataNascimento.toIso8601String();
    }

    return updateData;
  }

  /// Converte para Map para cache local (JSON)
  Map<String, dynamic> toJson() {
    return toMap();
  }

  /// Cria um ClienteModel a partir de JSON (cache local)
  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel.fromMap(json);
  }

  /// Cria uma cópia do ClienteModel com novos valores
  ClienteModel copyWith({
    String? id,
    String? authUserId,
    String? nome,
    String? username,
    String? email,
    String? telefone,
    String? pais,
    DateTime? dataNascimento,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClienteModel(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      nome: nome ?? this.nome,
      username: username ?? this.username,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      pais: pais ?? this.pais,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: this.updatedAt ?? updatedAt ?? DateTime.now(),
    );
  }

  /// Cria um ClienteModel vazio para registro inicial
  factory ClienteModel.forRegistration({
    required String authUserId,
    required String nome,
    required String username,
    required String email,
  }) {
    final now = DateTime.now();
    return ClienteModel(
      id: '', // Será gerado pelo banco
      authUserId: authUserId,
      nome: nome,
      username: username,
      email: email,
      telefone: null,
      pais: null,
      dataNascimento: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Valida se os dados do modelo estão consistentes
  bool isValid() {
    return id.isNotEmpty &&
           authUserId.isNotEmpty &&
           nome.isNotEmpty &&
           username.isNotEmpty &&
           email.isNotEmpty &&
           email.contains('@') &&
           username.length >= 3 &&
           nome.length >= 2;
  }

  /// Retorna uma versão sanitizada do modelo (remove dados sensíveis se necessário)
  ClienteModel sanitized() {
    // Por enquanto, não há dados sensíveis para remover
    // Mas pode ser útil no futuro
    return this;
  }

  @override
  String toString() {
    return 'ClienteModel(id: $id, nome: $nome, username: $username, email: $email, isComplete: $isProfileComplete)';
  }

  /// Compara dois ClienteModel para verificar se são iguais
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ClienteModel &&
           other.id == id &&
           other.authUserId == authUserId &&
           other.nome == nome &&
           other.username == username &&
           other.email == email &&
           other.telefone == telefone &&
           other.pais == pais &&
           other.dataNascimento == dataNascimento;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      authUserId,
      nome,
      username,
      email,
      telefone,
      pais,
      dataNascimento,
    );
  }
  
  get isProfileComplete => null;
}

