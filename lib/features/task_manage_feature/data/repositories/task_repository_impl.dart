import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:my_activity_tracker/core/failure.dart';

import 'package:my_activity_tracker/features/task_manage_feature/data/data_sources/task_data_source.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_entities.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_response_entity.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskDataSource taskDataSource;
  TaskRepositoryImpl(this.taskDataSource);

  @override
  Future<Either<Failure, String>> addTask(TaskEntity task) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Left(NetworkFailure());
    } else {
      try {
        final updateTaskList = await taskDataSource.addTask(task);
        return Right(updateTaskList);
      } catch (e) {
        return Left(FailureWithMessage("$e"));
      }
    }
  }

  @override
  Future<Either<Failure, String>> deleteTask(String task) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Left(NetworkFailure());
    } else {
      try {
        final updateTaskList = await taskDataSource.deleteTask(task);
        return Right(updateTaskList);
      } catch (e) {
        return Left(FailureWithMessage("$e"));
      }
    }
  }

  @override
  Future<Either<Failure, List<TaskResponseEntity>>> getRemoteTasks() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Left(NetworkFailure());
    } else {
      try {
        final getRemoteTaskList = await taskDataSource.getRemoteTasks();
        return Right(getRemoteTaskList);
      } catch (e) {
        return Left(FailureWithMessage("$e"));
      }
    }
  }

  @override
  Future<Either<Failure, String>> updateTask(TaskEntity task) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Left(NetworkFailure());
    } else {
      try {
        final updateTaskList = await taskDataSource.updateTask(task);
        return Right(updateTaskList);
      } catch (e) {
        return Left(FailureWithMessage("$e"));
      }
    }
  }

  @override
  Future<Either<Failure, List<TaskHiveModel>>> getLocalTasks() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Left(NetworkFailure());
    } else {
      try {
        final getLocalTaskList = await taskDataSource.getLocalTasks();
        return Right(getLocalTaskList);
      } catch (e) {
        return Left(FailureWithMessage("$e"));
      }
    }
  }
}
