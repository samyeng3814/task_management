import 'package:dartz/dartz.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/features/login_feature/domain/entities/login_auth_entity.dart';

abstract class LoginAuthRepository {
  Future<Either<Failure, LoginAuthEntity>> validateLoginUser(
    LoginCredentialEntity loginCredentialEntity,
  );
}
