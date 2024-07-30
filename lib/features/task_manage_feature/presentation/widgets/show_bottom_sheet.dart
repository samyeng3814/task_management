import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/navigation/navigation.dart';
import 'package:my_activity_tracker/core/theme/themes.dart';
import 'package:my_activity_tracker/core/utils/app_sized_box.dart';
import 'package:my_activity_tracker/core/utils/button_cubit.dart';
import 'package:my_activity_tracker/core/utils/elevated_button.dart';
import 'package:my_activity_tracker/core/utils/utils.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_state.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/pages/add_and_update_task.dart';

class TaskBottomSheet extends StatelessWidget {
  final TaskHiveModel taskModel;

  const TaskBottomSheet({Key? key, required this.taskModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyTaskCubit, MyTaskState>(
      builder: (context, state) {
        TaskHiveModel myTask = taskModel;
        if (state is MyTaskLoadedState) {
          myTask = state.res.firstWhere((task) => task.id == myTask.id);
        }
        return ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0)
                  .copyWith(bottom: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  iconContainer(
                    'expand_left_arrow',
                    () {
                      popContext(context);
                    },
                  ),
                  Row(
                    children: [
                      iconContainer('delete_icon', () {
                        popContext(context);
                        showAlert(context, myTask.id);
                      }),
                      AppSizedBox.w6,
                      iconContainer(
                        'edit_icon',
                        () {
                          pushContext(
                            context,
                            route: AddAndUpdateTaskPage(
                              pageName: 'Update',
                              taskHiveModel: myTask,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Task Title',
                  style: AppTheme.of(context)
                      .subtitle
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: const Color(0xff4caf50).withOpacity(0.2),
                  ),
                  child: Text(
                    myTask.status,
                    style: AppTheme.of(context).bodyText.copyWith(
                          fontSize: 12,
                          color: const Color(0xff4caf50),
                        ),
                  ),
                )
              ],
            ),
            AppSizedBox.h4,
            Text(
              myTask.title,
              style: AppTheme.of(context).title,
            ),
            AppSizedBox.h28,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Assigned user',
                        style: AppTheme.of(context)
                            .subtitle
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      AppSizedBox.h8,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                NetworkImage(myTask.assignedUserImgUrl),
                          ),
                          AppSizedBox.w8,
                          Text(
                            myTask.assignedUser,
                            style: AppTheme.of(context).bodyText.copyWith(
                                color: AppColors.customGreyColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date',
                        style: AppTheme.of(context)
                            .subtitle
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      AppSizedBox.h8,
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/calender_icon.svg',
                            height: 28,
                            width: 28,
                            colorFilter: const ColorFilter.mode(
                              AppColors.customGreyColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          AppSizedBox.w4,
                          Text(
                            DateFormat.yMMMMd().format(myTask.dueDate),
                            style: AppTheme.of(context).bodyText.copyWith(
                                color: AppColors.customGreyColor,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSizedBox.h16,
            Text(
              "Description",
              style: AppTheme.of(context)
                  .subtitle
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            AppSizedBox.h8,
            Text(
              myTask.description,
              style: AppTheme.of(context)
                  .bodyText
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            AppSizedBox.h12,
          ],
        );
      },
    );
  }

  Widget iconContainer(String icon, Function() onTap) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        color: AppColors.lighterGray.withOpacity(0.6),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(38),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          child: SvgPicture.asset(
            'assets/svg/$icon.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

void showAlert(BuildContext context, String taskId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocListener<MyTaskCubit, MyTaskState>(
        listener: (context, state) {
          if (state is MyTaskDeleteLoadingState) {
            context.read<ButtonCubit>().setLoading(true);
          } else if (state is MyTaskDeleteSuccessState) {
            context.read<ButtonCubit>().setLoading(false);
            popContext(context);
            Utils.showStatusSnackBar('Task deleted successfully', context);
          } else if (state is MyTaskErrorState) {
            if (state.failure is NetworkFailure) {
              popContext(context);
              Utils.showStatusSnackBar("No internet connection", context);
              context.read<ButtonCubit>().setLoading(false);
            } else {
              popContext(context);
              Utils.showStatusSnackBar("Something went wrong", context);
              context.read<ButtonCubit>().setLoading(false);
            }
          }
        },
        child: AlertDialog(
          backgroundColor: AppColors.whiteColor,
          contentPadding: const EdgeInsets.all(16.0),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 46,
                  width: 46,
                  child: SvgPicture.asset(
                    'assets/svg/delete_icon.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                AppSizedBox.h12,
                Text(
                  'Are you sure you want to delete this task?',
                  style: AppTheme.of(context)
                      .title
                      .copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                AppSizedBox.h24,
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Yes',
                        onPressed: () {
                          context.read<MyTaskCubit>().deleteTask(taskId);
                        },
                      ),
                    ),
                    AppSizedBox.w8,
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.blackColor),
                          elevation: 1,
                          padding: const EdgeInsets.all(16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                        onPressed: () {
                          popContext(context);
                        },
                        child: Text(
                          'Close',
                          style: AppTheme.of(context)
                              .subtitle
                              .copyWith(color: AppColors.blackColor),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
