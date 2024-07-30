part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {
  const UserInitialState();
}

class UserLoadingState extends UserState {
  const UserLoadingState();
}

class UsersLoadedState extends UserState {
  final List<UserEntity> list;
  const UsersLoadedState(this.list);
}

class UserLoadedState extends UserState {
  final UserHiveModel user;
  const UserLoadedState(this.user);
}

class UserNotAuthenticated extends UserState {}

class UserDetailLoadedState extends UserState {
  final UserEntity user;
  const UserDetailLoadedState(this.user);
}

class UserErrorState extends UserState {
  final Failure failure;
  const UserErrorState(this.failure);
}
