import 'package:dartz/dartz.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_entities.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_response_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskResponseEntity>>> getRemoteTasks();
  Future<Either<Failure, String>> addTask(TaskEntity task);
  Future<Either<Failure, String>> updateTask(TaskEntity task);
  Future<Either<Failure, String>> deleteTask(String task);
  Future<Either<Failure, List<TaskHiveModel>>> getLocalTasks();
}
