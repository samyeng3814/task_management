import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_activity_tracker/core/usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_entities.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/usecases/add_task_usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/usecases/delete_task_usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/usecases/get_local_task_usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/usecases/update_task_usecasee.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_state.dart';

class MyTaskCubit extends Cubit<MyTaskState> {
  GetLocalTaskUsecase getLocalTaskUsecase;
  AddTaskUsecase addTaskUsecase;
  UpdateTaskUsecase updateTaskUsecase;
  DeleteTaskUsecase deleteTaskUsecase;
  MyTaskCubit(
    this.getLocalTaskUsecase,
    this.addTaskUsecase,
    this.deleteTaskUsecase,
    this.updateTaskUsecase,
  ) : super(const MyTaskInitialState());

  List<TaskHiveModel> taskList = [];

  Future getTaskList() async {
    emit(const MyTaskLoadingState());
    emit(await executeMyTaskList());
  }

  Future<MyTaskState> executeMyTaskList() async {
    final response = await getLocalTaskUsecase(NoParams());
    return response.fold(
      (failure) => MyTaskErrorState(failure),
      (success) {
        taskList = success;
        return MyTaskLoadedState(success);
      },
    );
  }

  Future<void> addTask(TaskEntity task) async {
    emit(const MyTaskAddLoadingState());
    final response = await addTaskUsecase(task);
    emit(response.fold(
      (failure) => MyTaskErrorState(failure),
      (success) {
        getTaskList();
        return MyTaskAddSuccessState(success);
      },
    ));
  }

  Future<void> updateTask(TaskEntity task) async {
    emit(const MyTaskUpdateLoadingState());
    final response = await updateTaskUsecase(task);
    emit(response.fold(
      (failure) => MyTaskErrorState(failure),
      (success) {
        getTaskList();
        var task = taskList.firstWhere((task) => task.id == task.id);
        return MyTaskUpdateSuccessState(task, success);
      },
    ));
  }

  Future<void> deleteTask(String taskId) async {
    emit(const MyTaskDeleteLoadingState());
    final response = await deleteTaskUsecase(taskId);
    emit(response.fold(
      (failure) => MyTaskErrorState(failure),
      (success) {
        getTaskList();
        return MyTaskDeleteSuccessState(success);
      },
    ));
  }
}
