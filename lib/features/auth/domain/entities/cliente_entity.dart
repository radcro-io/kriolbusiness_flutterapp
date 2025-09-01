import 'package:equatable/equatable.dart';
import 'package:kriolbusiness/features/auth/domain/entities/user_entity.dart';

class ClienteEntity extends Equatable {
  final UserEntity user;
  final DateTime? dataNascimento;

  const ClienteEntity({
    required this.user,
    this.dataNascimento,
  });

  @override
  List<Object?> get props => [
    user, dataNascimento
  ];
  
  @override
  String toString() {
    return 'ClienteEntity{user: $user, dataNascimento: $dataNascimento}';
  }
}