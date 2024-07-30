import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/constant.dart';
import 'package:my_activity_tracker/core/theme/themes.dart';
import 'package:my_activity_tracker/core/utils/app_sized_box.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_response_entity.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/task_manage_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/task_manage_state.dart';
import 'package:my_activity_tracker/features/user/presentation/cubit/user_cubit.dart';

class AllTaskHomePage extends StatefulWidget {
  const AllTaskHomePage({super.key});

  @override
  State<AllTaskHomePage> createState() => _AllTaskHomePageState();
}

class _AllTaskHomePageState extends State<AllTaskHomePage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUser();
    context.read<TaskCubit>().getTaskList();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      0.6,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        if (state is UserLoadedState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(state.user.avatarUrl),
                                    radius: 34,
                                  ),
                                  AppSizedBox.w12,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.user.username,
                                        style:
                                            AppTheme.of(context).title.copyWith(
                                                  fontSize: 22,
                                                ),
                                      ),
                                      AppSizedBox.h4,
                                      Text(
                                        state.user.email,
                                        style: AppTheme.of(context)
                                            .bodyText
                                            .copyWith(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 34,
                                child: SvgPicture.asset(
                                  'assets/svg/profile_icon.svg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
                AppSizedBox.h20,
                Text(
                  'Overall Tasks',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                AppSizedBox.h12,
                SizedBox(
                  height: screenHeight * 0.72,
                  child: BlocBuilder<TaskCubit, TaskState>(
                    builder: (context, state) {
                      if (state is TaskLoadingState) {
                        return const Center(
                          child: SpinKitFadingCircle(
                            color: AppColors.yellowColor,
                            size: 32,
                          ),
                        );
                      } else if (state is TaskLoadedState) {
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: state.res.length,
                          itemBuilder: (context, index) {
                            return  _buildTaskItem(
                                        context, state.res[index], index);
                          },
                        );
                      } else if (state is TaskErrorState) {
                        return Center(
                          child: Text(
                            'Something went wrong',
                            style: AppTheme.of(context).title,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(
      BuildContext context, TaskResponseEntity task, int index) {
    return Card(
      color: AppColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: getRandomColor(),
                  child: Text(
                    task.title[0].toUpperCase(),
                    style: AppTheme.of(context).bodyText.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                  ),
                ),
                AppSizedBox.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: AppTheme.of(context).bodyText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSizedBox.h12,
            Row(
              children: [
                Text(
                  'Status :',
                  style: AppTheme.of(context)
                      .bodyText
                      .copyWith(color: const Color(0xFFA7A7A7)),
                ),
                AppSizedBox.w12,
                Text(
                  task.completed ? "Completed" : "Not Completed",
                  style: AppTheme.of(context).bodyText.copyWith(
                        fontSize: 14,
                        color: task.completed ? Colors.green : Colors.red,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
