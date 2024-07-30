import 'package:dartz/dartz.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_response_entity.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/repositories/task_repository.dart';

class GetRemoteTaskUsecase implements UseCase<List<TaskResponseEntity>, NoParams> {
  final TaskRepository taskRepository;

  GetRemoteTaskUsecase(this.taskRepository);
  @override
  Future<Either<Failure, List<TaskResponseEntity>>> call(
    noParams,
  ) async {
    return await taskRepository.getRemoteTasks();
  }
}
