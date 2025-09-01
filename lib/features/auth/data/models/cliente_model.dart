import 'package:kriolbusiness/features/auth/data/models/user_model.dart';
import 'package:kriolbusiness/features/auth/domain/entities/cliente_entity.dart';

/// Modelo de dados do cliente
/// Estende a entidade e adiciona métodos de conversão para Supabase
/// Compatível com a estrutura da tabela 'clientes' no banco de dados
class ClienteModel extends ClienteEntity {
  const ClienteModel({
    required super.user,
    super.dataNascimento,
  }) : super();

  /// Construtor de fábrica para criar uma instância a partir de um JSON
  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      dataNascimento: json['data_nascimento'] != null
          ? DateTime.parse(json['data_nascimento'] as String)
          : null,
    );
  }

  /// Converte a instância do modelo em um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserModel).toJson(), // Certifique-se de que user é do tipo UserModel
      'data_nascimento': dataNascimento?.toIso8601String(),
    };
  }
}

