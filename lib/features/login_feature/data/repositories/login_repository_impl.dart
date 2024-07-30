import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

import 'package:my_activity_tracker/core/failure.dart';

import 'package:my_activity_tracker/features/login_feature/data/datasources/login_remote_datasource.dart';
import 'package:my_activity_tracker/features/login_feature/domain/entities/login_auth_entity.dart';
import 'package:my_activity_tracker/features/login_feature/domain/repositories/login_auth_repository.dart';

class LoginRepositoryImpl implements LoginAuthRepository {
  final LoginRemoteDataSource loginRemoteDataSource;
  LoginRepositoryImpl(this.loginRemoteDataSource);

  @override
  Future<Either<Failure, LoginAuthEntity>> validateLoginUser(
      LoginCredentialEntity loginCredentialEntity) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Left(NetworkFailure());
    } else {
      try {
        final validatedUser =
            await loginRemoteDataSource.userLogin(loginCredentialEntity);
        return Right(validatedUser);
      } catch (e) {
        return Left(FailureWithMessage("$e"));
      }
    }
  }
}
