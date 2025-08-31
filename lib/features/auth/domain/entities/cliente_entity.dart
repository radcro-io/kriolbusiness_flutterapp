import 'package:equatable/equatable.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';

class ClienteEntity extends Equatable {
  final String id;
  final String authUserId;
  final String nome;
  final String username;
  final String email;
  final String? telefone;
  final String? pais;
  final DateTime? dataNascimento;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Composição com UserEntity
//  final UserEntity? user;

  const ClienteEntity({
    required this.id,
    required this.authUserId,
    required this.nome,
    required this.username,
    required this.email,
    this.telefone,
    this.pais,
    this.dataNascimento,
    required this.createdAt,
    this.updatedAt,
    //this.user,
  });

  @override
  List<Object?> get props => [
    id, authUserId, nome, username, email, telefone, 
    pais, dataNascimento, createdAt, updatedAt
  ];
  
  get isProfileComplete => null;

  @override
  String toString() {
    return 'ClienteEntity(id: $id, nome: $nome, username: $username, email: $email, isComplete: $isProfileComplete)';
  }
}