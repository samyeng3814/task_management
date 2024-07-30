import 'package:dartz/dartz.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/repositories/task_repository.dart';

class GetLocalTaskUsecase implements UseCase<List<TaskHiveModel>, NoParams> {
  final TaskRepository taskRepository;

  GetLocalTaskUsecase(this.taskRepository);
  @override
  Future<Either<Failure, List<TaskHiveModel>>> call(
    noParams,
  ) async {
    return await taskRepository.getLocalTasks();
  }
}
