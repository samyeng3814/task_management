import 'package:dartz/dartz.dart';

import 'package:my_activity_tracker/core/failure.dart';

import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUserList();
  Future<Either<Failure, UserEntity>> getUserDetail(String email);
}
