import 'package:dartz/dartz.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/usecase.dart';
import 'package:my_activity_tracker/features/login_feature/domain/entities/login_auth_entity.dart';
import 'package:my_activity_tracker/features/login_feature/domain/repositories/login_auth_repository.dart';

class LoginAuthUsecase
    implements UseCase<LoginAuthEntity, LoginCredentialEntity> {
  final LoginAuthRepository repository;

  LoginAuthUsecase(this.repository);
  @override
  Future<Either<Failure, LoginAuthEntity>> call(
    LoginCredentialEntity loginCredentialEntity,
  ) async {
    return await repository.validateLoginUser(loginCredentialEntity);
  }
}
