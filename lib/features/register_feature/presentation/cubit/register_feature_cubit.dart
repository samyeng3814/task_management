import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_activity_tracker/features/register_feature/domain/entities/register_entity.dart';
import 'package:my_activity_tracker/features/register_feature/domain/usecases/register_usecase.dart';

import 'Register_feature_state.dart';

class RegisterFeatureCubit extends Cubit<RegisterFeatureState> {
  RegisterUsecase registerUseCase;
  RegisterFeatureCubit(this.registerUseCase)
      : super(const RegisterInitialState());

  emitLoginInitialState() => emit(const RegisterInitialState());

  Future<void> validateUserRegister(
      RegisterCredentialEntity registerCredentialEntity) async {
    emit(const RegisterLoadingState());
    emit(await execute(
      registerCredentialEntity.email,
      registerCredentialEntity.password,
      registerCredentialEntity.firstName,
      registerCredentialEntity.lastName,
    ));
  }

  Future<RegisterFeatureState> execute(
      String email, String password, String firstName, String lastName) async {
    final response = await registerUseCase(
      RegisterCredentialEntity(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      ),
    );

    return response.fold(
      (failure) => (RegisterErrorState(failure)),
      (success) => RegisterLoadedState(success),
    );
  }
}
