import 'package:dartz/dartz.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/features/register_feature/domain/entities/register_entity.dart';

abstract class RegisterRepository {
  Future<Either<Failure, RegisterEntity>> validateRegisterUser(
    RegisterCredentialEntity registerCredentialEntity,
  );
}
