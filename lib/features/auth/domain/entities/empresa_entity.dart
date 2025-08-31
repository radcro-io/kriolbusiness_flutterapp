import 'package:equatable/equatable.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';

class EmpresaEntity extends Equatable {
  final String id;
  final String authUserId;
  final String nome;
  final String username;
  final String email;
  final String? telefone;
  final String? pais;
  final String? endereco;
  final double? latitude;
  final double? longitude;
  final String? idSubcategoria;
  final String? descricao;
  final String? informacoesAdicionais;
  final String createdAt;
  final String? updatedAt;
  
  // Composição com UserEntity
  final UserEntity? user;

  const EmpresaEntity({
    required this.id,
    required this.authUserId,
    required this.nome,
    required this.username,
    required this.email,
    this.telefone,
    this.pais,
    this.endereco,
    this.latitude,
    this.longitude,
    this.idSubcategoria,
    this.descricao,
    this.informacoesAdicionais,
    required this.createdAt,
    this.updatedAt,
    this.user, 
  });

  @override
  List<Object?> get props => [
    id, authUserId, nome, username, email, telefone, pais, endereco,
    latitude, longitude, idSubcategoria, descricao, informacoesAdicionais,
    createdAt, updatedAt, user
  ];
}