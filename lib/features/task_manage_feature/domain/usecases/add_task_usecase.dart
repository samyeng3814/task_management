import 'package:dartz/dartz.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_entities.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/repositories/task_repository.dart';

class AddTaskUsecase implements UseCase<String, TaskEntity> {
  final TaskRepository taskRepository;

  AddTaskUsecase(this.taskRepository);
  @override
  Future<Either<Failure, String>> call(
    taskEntity,
  ) async {
    return await taskRepository.addTask(taskEntity);
  }
}
