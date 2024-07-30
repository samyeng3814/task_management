import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/usecase.dart';
import 'package:my_activity_tracker/features/user/data/models/user_hive_model.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_user_detail_usecase.dart';
import '../../domain/usecases/get_user_list_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  GetUserListUsecase getUserListUsecase;
  GetUserDetailUsecase getUserDetailUsecase;

  UserCubit(
    this.getUserListUsecase,
    this.getUserDetailUsecase,
  ) : super(const UserInitialState());

  Future<void> getUserDetail(String email) async {
    emit(const UserLoadingState());
    emit(await executeDetail(email));
  }

  Future<void> getUserList() async {
    emit(const UserLoadingState());
    emit(await executeUserList());
  }

  Future<UserState> executeUserList() async {
    final response = await getUserListUsecase(NoParams());
    return response.fold(
      (failure) => UserErrorState(failure),
      (success) => UsersLoadedState(success),
    );
  }

  Future<UserState> executeDetail(String email) async {
    final response = await getUserDetailUsecase(email);
    return response.fold(
      (failure) => UserErrorState(failure),
      (success) => UserDetailLoadedState(success),
    );
  }

  Future<void> loadUser() async {
    final userBox = Hive.box<UserHiveModel>('userBox');
    final user = userBox.get('currentUser');
    if (user != null) {
      emit(UserLoadedState(user));
    } else {
      emit(UserNotAuthenticated());
    }
  }

  Future<void> updateUser(UserHiveModel user) async {
    final userBox = Hive.box<UserHiveModel>('userBox');
    await userBox.put('currentUser', user);
    emit(UserLoadedState(user));
  }
}
