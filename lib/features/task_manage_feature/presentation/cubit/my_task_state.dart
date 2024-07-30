import 'package:equatable/equatable.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';

abstract class MyTaskState extends Equatable {
  const MyTaskState();

  @override
  List<Object> get props => [];
}

class MyTaskInitialState extends MyTaskState {
  const MyTaskInitialState();
}

class MyTaskLoadingState extends MyTaskState {
  const MyTaskLoadingState();
}

class MyTaskAddLoadingState extends MyTaskState {
  const MyTaskAddLoadingState();
}

class MyTaskUpdateLoadingState extends MyTaskState {
  const MyTaskUpdateLoadingState();
}

class MyTaskDeleteLoadingState extends MyTaskState {
  const MyTaskDeleteLoadingState();
}

class MyTaskAddSuccessState extends MyTaskState {
  final String successString;
  const MyTaskAddSuccessState(this.successString);
}

class MyTaskUpdateSuccessState extends MyTaskState {
  final TaskHiveModel res;
  final String successString;
  const MyTaskUpdateSuccessState(this.res, this.successString);
}

class MyTaskDeleteSuccessState extends MyTaskState {
  final String successString;
  const MyTaskDeleteSuccessState(this.successString);
}

class MyTaskLoadedState extends MyTaskState {
  final List<TaskHiveModel> res;
  const MyTaskLoadedState(this.res);
}

class MyTaskErrorState extends MyTaskState {
  final Failure failure;
  const MyTaskErrorState(this.failure);
}
