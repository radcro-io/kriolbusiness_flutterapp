import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? username;
  final String? emailConfirmedAt;
  final String createdAt;
  final String? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.username,
    this.emailConfirmedAt,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id, email, name, username, emailConfirmedAt, createdAt, updatedAt
  ];

  Map<String, String?> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'username': username,
      'email_confirmed_at': emailConfirmedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}