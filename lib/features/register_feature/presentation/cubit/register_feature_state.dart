import 'package:equatable/equatable.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/features/register_feature/domain/entities/register_entity.dart';

abstract class RegisterFeatureState extends Equatable {
  const RegisterFeatureState();

  @override
  List<Object> get props => [];
}

class RegisterInitialState extends RegisterFeatureState {
  const RegisterInitialState();
}

class RegisterLoadingState extends RegisterFeatureState {
  const RegisterLoadingState();
}

class RegisterLoadedState extends RegisterFeatureState {
  final RegisterEntity res;
  const RegisterLoadedState(this.res);
}

class RegisterErrorState extends RegisterFeatureState {
  final Failure failure;
  const RegisterErrorState(this.failure);
}
