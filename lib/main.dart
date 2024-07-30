import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_activity_tracker/core/splash/splash_screen.dart';
import 'package:my_activity_tracker/core/utils/button_cubit.dart';
import 'package:my_activity_tracker/core/utils/hive_model_adaptor.dart';

import 'package:my_activity_tracker/features/login_feature/presentation/cubit/login_feature_cubit.dart';
import 'package:my_activity_tracker/features/register_feature/presentation/cubit/register_feature_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/bottom_nav_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/task_manage_cubit.dart';
import 'package:my_activity_tracker/features/user/presentation/cubit/user_cubit.dart';

import 'package:my_activity_tracker/injection_container.dart' as di;

Future<void> main() async {
  await di.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserHiveModelAdapter());
  Hive.registerAdapter(TaskHiveModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ButtonCubit(),
        ),
        BlocProvider(
          create: (_) => di.sl<LoginCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<RegisterFeatureCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<UserCubit>(),
        ),
        BlocProvider(
          create: (_) => BottomNavCubit(),
        ),
        BlocProvider(
          create: (_) => di.sl<MyTaskCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<TaskCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Management',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
