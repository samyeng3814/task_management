import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/constant.dart';
import 'package:my_activity_tracker/core/navigation/navigation.dart';
import 'package:my_activity_tracker/features/login_feature/presentation/pages/login_page.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/pages/home_page.dart';
import 'package:my_activity_tracker/features/user/data/models/user_hive_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox<UserHiveModel>('userBox');
    navigatePage();
  }

  Future<void> navigatePage() async {
    final user = await getUser();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (user != null) {
          context.read<MyTaskCubit>().getTaskList();
          pushReplacementContext(context, route: const HomePage());
        } else {
          pushReplacementContext(context, route: const LoginPage());
        }
      },
    );
  }

  Future<UserHiveModel?> getUser() async {
    final userBox = Hive.box<UserHiveModel>('userBox');
    return userBox.isNotEmpty ? userBox.get('currentUser') : null;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          color: AppColors.blackColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 184,
                width: 184,
                child: Lottie.asset('assets/lottie/task_manage_lottie.json'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
