import 'package:dartz/dartz.dart';
import 'package:kriolbusiness/core/error/failures.dart';
import 'package:kriolbusiness/features/auth/domain/repository/auth_repository.dart';


class IsUsernameAvailableUseCase {
  final AuthRepository authRepository;

  IsUsernameAvailableUseCase(this.authRepository);

  Future<Either<Failure, bool>> call(String username) async {
    return await authRepository.isUsernameAvailable(username);
  }
}