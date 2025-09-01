import 'package:equatable/equatable.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';

class EmpresaEntity extends Equatable {
  final UserEntity user;
  final String? endereco;
  final String? latitude;
  final String? longitude;
  final String? idSubcategoria;
  final String? descricao;
  final String? informacoesAdicionais;
  
  const EmpresaEntity({
    required this.user,
    this.endereco,
    this.latitude,
    this.longitude,
    this.idSubcategoria,
    this.descricao,
    this.informacoesAdicionais, 
  });

  @override
  List<Object?> get props => [
    user, endereco, latitude, longitude, idSubcategoria, descricao, informacoesAdicionais
  ];
}