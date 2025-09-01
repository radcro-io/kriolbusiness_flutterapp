import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String authUserId;
  final String email;
  final String nome;
  final String username;
  final String? pais;
  final String? telefone;

  const UserEntity({
    required this.authUserId,
    required this.email,
    required this.nome,
    required this.username,
    this.pais,
    this.telefone,
  });

  @override
  List<Object?> get props => [
    authUserId, email, nome, username, pais, telefone
  ];

  Map<String, String?> toJson() {
    return {
      'authUserId': authUserId,
      'email': email,
      'name': nome,
      'username': username,
      'pais': pais,
      'telefone': telefone,
    };
  }
}