import 'package:equatable/equatable.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_response_entity.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitialState extends TaskState {
  const TaskInitialState();
}

class TaskLoadingState extends TaskState {
  const TaskLoadingState();
}

class TaskLoadedState extends TaskState {
  final List<TaskResponseEntity> res;
  const TaskLoadedState(this.res);
}

class TaskErrorState extends TaskState {
  final Failure failure;
  const TaskErrorState(this.failure);
}
// class TaksAddedState extends TaskState {
//   const TaksAddedState();
// }

// class TaskUpdatedState extends TaskState {
//   const TaskUpdatedState();
// }

// class TaskDeletedState extends TaskState {
//   const TaskDeletedState();
// }


