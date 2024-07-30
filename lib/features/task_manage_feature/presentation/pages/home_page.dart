import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/constant.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/bottom_nav_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/pages/my_task_page.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/pages/reminder_page.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/pages/task_manage_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _pageNavigation = const [
    MyTaskPage(),
    AllTaskHomePage(),
    RemiderPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(state),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: state,
            onTap: _getChangeBottomNav,
          ),
        );
      },
    );
  }

  Widget _buildBody(int index) {
    return _pageNavigation.elementAt(index);
  }

  void _getChangeBottomNav(int index) {
    context.read<BottomNavCubit>().updateIndex(index);
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = screenWidth / 3;
    return Stack(
      children: [
        BottomNavigationBar(
          backgroundColor: AppColors.whiteColor,
          elevation: 8,
          mouseCursor: SystemMouseCursors.grab,
          selectedFontSize: 14,
          selectedItemColor: AppColors.blackColor,
          currentIndex: currentIndex,
          unselectedItemColor: AppColors.hintTextColor,
          onTap: onTap,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/home_outlined.svg',
                height: 28,
                width: 28,
                fit: BoxFit.cover,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/task_list.svg',
                height: 28,
                width: 28,
                fit: BoxFit.cover,
              ),
              label: "All Tasks",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/reminder.svg',
                height: 28,
                width: 28,
                fit: BoxFit.cover,
              ),
              label: "Reminder",
            ),
          ],
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: 0,
          left: width * currentIndex,
          right: screenWidth - (width * (currentIndex + 1)),
          child: Container(
            width: screenWidth / 3,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}
