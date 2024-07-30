import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/features/register_feature/data/data_sources/register_remote_datasource.dart';

import 'package:my_activity_tracker/features/register_feature/domain/entities/register_entity.dart';
import 'package:my_activity_tracker/features/register_feature/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource registerRemoteDataSource;
  RegisterRepositoryImpl(this.registerRemoteDataSource);
  @override
  Future<Either<Failure, RegisterEntity>> validateRegisterUser(
      RegisterCredentialEntity registerCredentialEntity) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Left(NetworkFailure());
    } else {
      try {
        final validatedUser = await registerRemoteDataSource
            .userRegister(registerCredentialEntity);
        return Right(validatedUser);
      } catch (e) {
        return Left(FailureWithMessage("$e"));
      }
    }
  }
}
