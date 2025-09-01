import 'package:kriolbusiness/features/auth/domain/entities/empresa_entity.dart';
import 'package:kriolbusiness/features/auth/data/models/user_model.dart';

class EmpresaModel extends EmpresaEntity {
  const EmpresaModel({
    required super.user,
    super.endereco,
    super.latitude,
    super.longitude,
    super.idSubcategoria,
    super.descricao,
    super.informacoesAdicionais,
  }) : super();

  factory EmpresaModel.fromJson(Map<String, dynamic> json) {
    return EmpresaModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      endereco: json['endereco'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      idSubcategoria: json['id_subcategoria'] as String?,
      descricao: json['descricao'] as String?,
      informacoesAdicionais: json['informacoes_adicionais'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserModel).toJson(), // Certifique-se de que user é do tipo UserModel
      'endereco': endereco,
      'latitude': latitude,
      'longitude': longitude,
      'idSubcategoria': idSubcategoria,
      'descricao': descricao,
      'informacoesAdicionais': informacoesAdicionais,
    };
  }
  
}