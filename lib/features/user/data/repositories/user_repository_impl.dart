import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';

import 'package:my_activity_tracker/core/failure.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl({required this.userRemoteDataSource});

  @override
  Future<Either<Failure, List<UserEntity>>> getUserList() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Left(NetworkFailure());
    } else {
      try {
        final response = await userRemoteDataSource.getUserList();
        return Right(response);
      } catch (e) {
        return Left(FailureWithMessage("Invalid user"));
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserDetail(String email) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Left(NetworkFailure());
    } else {
      try {
        final response = await userRemoteDataSource.getUserDetail(email);
        return Right(response);
      } catch (e) {
        return Left(FailureWithMessage("Invalid User"));
      }
    }
  }
}
