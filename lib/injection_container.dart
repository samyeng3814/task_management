import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:my_activity_tracker/features/login_feature/data/datasources/login_remote_datasource.dart';
import 'package:my_activity_tracker/features/login_feature/data/repositories/login_repository_impl.dart';
import 'package:my_activity_tracker/features/login_feature/domain/repositories/login_auth_repository.dart';
import 'package:my_activity_tracker/features/login_feature/domain/usecases/login_auth_usecase.dart';
import 'package:my_activity_tracker/features/login_feature/presentation/cubit/login_feature_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/data_sources/task_data_source.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/repositories/task_repository_impl.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/repositories/task_repository.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/usecases/add_task_usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/usecases/delete_task_usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/usecases/get_local_task_usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/usecases/get_remote_tasks_usecase.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/usecases/update_task_usecasee.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/task_manage_cubit.dart';
import 'package:my_activity_tracker/features/user/data/datasources/user_remote_datasource.dart';
import 'package:my_activity_tracker/features/user/data/repositories/user_repository_impl.dart';
import 'package:my_activity_tracker/features/user/domain/repositories/user_repository.dart';
import 'package:my_activity_tracker/features/user/domain/usecases/get_user_detail_usecase.dart';
import 'package:my_activity_tracker/features/user/domain/usecases/get_user_list_usecase.dart';
import 'package:my_activity_tracker/features/user/presentation/cubit/user_cubit.dart';

import 'features/register_feature/data/data_sources/register_remote_datasource.dart';
import 'features/register_feature/data/repositories/register_repository_impl.dart';
import 'features/register_feature/domain/repositories/register_repository.dart';
import 'features/register_feature/domain/usecases/register_usecase.dart';
import 'features/register_feature/presentation/cubit/register_feature_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerLazySingleton(
    () => Connectivity(),
  );

  sl.registerFactory(
    () => LoginCubit(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<LoginAuthUsecase>(
    () => LoginAuthUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<LoginAuthRepository>(
    () => LoginRepositoryImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(),
  );

  sl.registerFactory(
    () => RegisterFeatureCubit(
      sl(),
    ),
  );
  sl.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(),
  );

  sl.registerFactory(
    () => UserCubit(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<GetUserDetailUsecase>(
    () => GetUserDetailUsecase(
      userRepository: sl(),
    ),
  );
  sl.registerLazySingleton<GetUserListUsecase>(
    () => GetUserListUsecase(
      userRepository: sl(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      userRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );

  sl.registerFactory(
    () => TaskCubit(
      sl(),
    ),
  );

  sl.registerFactory(
    () => MyTaskCubit(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );

  sl.registerLazySingleton<GetLocalTaskUsecase>(
    () => GetLocalTaskUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<AddTaskUsecase>(
    () => AddTaskUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<UpdateTaskUsecase>(
    () => UpdateTaskUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<DeleteTaskUsecase>(
    () => DeleteTaskUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<GetRemoteTaskUsecase>(
    () => GetRemoteTaskUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<TaskDataSource>(
    () => TaskDataSourceImpl(),
  );
}
