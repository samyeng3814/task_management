import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/features/login_feature/domain/entities/login_auth_entity.dart';
import 'package:my_activity_tracker/features/login_feature/domain/usecases/login_auth_usecase.dart';
import 'package:my_activity_tracker/features/user/data/models/user_hive_model.dart';
import 'package:my_activity_tracker/features/user/presentation/cubit/user_cubit.dart';

part 'login_feature_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginAuthUsecase userValidationUseCase;
  UserCubit userCubit;

  LoginCubit(this.userCubit, this.userValidationUseCase)
      : super(
          const LoginInitialState(),
        );

  emitLoginInitialState() => emit(const LoginInitialState());

  Future<void> validateUserLogin(
      LoginCredentialEntity loginCredentialEntity) async {
    emit(const LoginLoadingState());
    emit(await execute(
        loginCredentialEntity.email, loginCredentialEntity.password));
  }

  Future<LoginState> execute(String email, String password) async {
    final response = await userValidationUseCase(
      LoginCredentialEntity(email: email, password: password),
    );

    return response.fold(
      (failure) => (LoginErrorState(failure)),
      (success) {
        return LoginLoadedState(success);
      },
    );
  }

  Future<void> logout() async {
    final box = Hive.box<UserHiveModel>('userBox');
    await box.delete('currentUser');
    emit(const LogOutState());
  }
}
