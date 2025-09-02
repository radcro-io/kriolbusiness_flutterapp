import 'package:gotrue/src/types/user.dart';
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

   /// Cria EmpresaModel a partir de dados do Supabase
  factory EmpresaModel.fromSupabaseData({
    required Map<String, dynamic> userData,
    required Map<String, dynamic> empresaData,
  }) {
    return EmpresaModel(
      user: UserModel.fromSupabaseUser(userData as User),
      endereco: empresaData['endereco'] as String?,
      latitude: empresaData['latitude'] as String?,
      longitude: empresaData['longitude'] as String?,
      idSubcategoria: empresaData['id_subcategoria'] as String?,
      descricao: empresaData['descricao'] as String?,
      informacoesAdicionais: empresaData['informacoes_adicionais'] as String?,
    );
  }

  /// Converte para Map para inserção na tabela empresas
  Map<String, dynamic> toEmpresaInsertMap() {
    return {
      'auth_user_id': user.authUserId,
      'nome': user.nome,
      'username': user.username,
      'email': user.email,
      'telefone': user.telefone,
      'pais': user.pais,
      'endereco': endereco,
      'latitude': latitude,
      'longitude': longitude,
      'id_subcategoria': idSubcategoria,
      'descricao': descricao,
      'informacoes_adicionais': informacoesAdicionais,
    };
  }

  /// Cria EmpresaModel para registro inicial (apenas dados básicos)
  factory EmpresaModel.forRegistration({
    required String authUserId,
    required String nome,
    required String username,
    required String email,
  }) {
    return EmpresaModel(
      user: UserModel(
        authUserId: authUserId,
        email: email,
        nome: nome,
        username: username,
        pais: null,
        telefone: null,
      ),
      endereco: null,
      latitude: null,
      longitude: null,
      idSubcategoria: null,
      descricao: null,
      informacoesAdicionais: null,
    );
  }

  /// Cria cópia com novos valores
  EmpresaModel copyWith({
    UserModel? user,
    String? endereco,
    String? latitude,
    String? longitude,
    String? idSubcategoria,
    String? descricao,
    String? informacoesAdicionais,
  }) {
    return EmpresaModel(
      user: user ?? this.user as UserModel,
      endereco: endereco ?? this.endereco,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      idSubcategoria: idSubcategoria ?? this.idSubcategoria,
      descricao: descricao ?? this.descricao,
      informacoesAdicionais: informacoesAdicionais ?? this.informacoesAdicionais,
    );
  }

  @override
  String toString() {
    return 'EmpresaModel(user: ${user.nome}, username: ${user.username})';
  }
  
}