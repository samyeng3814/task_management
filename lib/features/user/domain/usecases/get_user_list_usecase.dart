import 'package:dartz/dartz.dart';

import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/usecase.dart';

import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserListUsecase implements UseCase<List<UserEntity>, NoParams> {
  final UserRepository userRepository;

  GetUserListUsecase({required this.userRepository});

  @override
  Future<Either<Failure, List<UserEntity>>> call(NoParams params) async =>
      await userRepository.getUserList();
}
