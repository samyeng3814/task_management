
import 'package:dartz/dartz.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/usecase.dart';
import 'package:my_activity_tracker/features/register_feature/domain/entities/register_entity.dart';
import 'package:my_activity_tracker/features/register_feature/domain/repositories/register_repository.dart';

class RegisterUsecase
    implements UseCase<RegisterEntity, RegisterCredentialEntity> {
  final RegisterRepository repository;

  RegisterUsecase(this.repository);
  @override
  Future<Either<Failure, RegisterEntity>> call(
    RegisterCredentialEntity registerCredentialEntity,
  ) async {
    return await repository.validateRegisterUser(registerCredentialEntity);
  }
}
