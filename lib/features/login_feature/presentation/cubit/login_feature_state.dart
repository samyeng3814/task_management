part of 'login_feature_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {
  const LoginInitialState();
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState();
}

class LoginLoadedState extends LoginState {
  final LoginAuthEntity res;
  const LoginLoadedState(this.res);
}

class LoginErrorState extends LoginState {
  final Failure failure;
  const LoginErrorState(this.failure);
}

class LogOutState extends LoginState {
  const LogOutState();
}
