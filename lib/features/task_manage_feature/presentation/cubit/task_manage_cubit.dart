import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_activity_tracker/core/usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/usecases/get_remote_tasks_usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/task_manage_state.dart';

class TaskCubit extends Cubit<TaskState> {
  GetRemoteTaskUsecase getRemoteTaskUsecase;
  TaskCubit( this.getRemoteTaskUsecase)
      : super(const TaskInitialState());

  Future<void> getTaskList() async {
    emit(const TaskLoadingState());
    emit(await executeTaskList());
  }

  Future<TaskState> executeTaskList() async {
    final response = await getRemoteTaskUsecase(NoParams());
    return response.fold(
      (failure) => TaskErrorState(failure),
      (success) => TaskLoadedState(success),
    );
  }
}
