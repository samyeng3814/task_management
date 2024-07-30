import 'package:dartz/dartz.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/repositories/task_repository.dart';

class DeleteTaskUsecase implements UseCase<String, String> {
  final TaskRepository taskRepository;

  DeleteTaskUsecase(this.taskRepository);
  @override
  Future<Either<Failure, String>> call(
    String task,
  ) async {
    return await taskRepository.deleteTask(task);
  }
}
