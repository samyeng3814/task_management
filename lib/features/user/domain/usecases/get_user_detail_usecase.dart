import 'package:dartz/dartz.dart';

import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/usecase.dart';

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserDetailUsecase implements UseCase<UserEntity, String> {
  final UserRepository userRepository;

  GetUserDetailUsecase({required this.userRepository});

  @override
  Future<Either<Failure, UserEntity>> call(String email) async =>
      await userRepository.getUserDetail(email);
}
