import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/constant.dart';
import 'package:my_activity_tracker/core/theme/themes.dart';
import 'package:my_activity_tracker/core/utils/app_sized_box.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_state.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/widgets/show_bottom_sheet.dart';

class RemiderPage extends StatefulWidget {
  const RemiderPage({super.key});

  @override
  State<RemiderPage> createState() => RemiderPageState();
}

class RemiderPageState extends State<RemiderPage>
    with TickerProviderStateMixin {
  List<AnimationController> animationControllers = [];

  @override
  void initState() {
    super.initState();
    context.read<MyTaskCubit>().getTaskList();
    
  }

  @override
  void dispose() {
    for (var animationController in animationControllers) {
      animationController.dispose();
    }
    super.dispose();
  }

  void _createAnimationController(int index) {
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    animationControllers.add(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Reminder",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MyTaskCubit, MyTaskState>(
          builder: (context, state) {
            if (state is MyTaskLoadingState) {
              return const Center(
                child: SpinKitFadingCircle(
                  color: AppColors.yellowColor,
                  size: 32,
                ),
              );
            } else if (state is MyTaskLoadedState) {
              var reminderList = [];
              for (int i = 0; i < state.res.length; i++) {
                if (state.res[i].isReminded) {
                  reminderList.add(state.res[i]);
                }
              }
              if (reminderList.isEmpty) {
                return Center(
                  child: Text(
                    'No reminder task added yet',
                    style: AppTheme.of(context).title,
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.8,
                          child: ListView.builder(
                            itemCount: reminderList.length,
                            itemBuilder: (context, index) {
                              _createAnimationController(index);
                              return buildReminderTask(
                                context: context,
                                index: index,
                                onTap: () {
                                  showTaskBottomSheet(
                                      context, reminderList[index]);
                                },
                                priority: reminderList[index].priority,
                                time: DateFormat.yMMMMd()
                                    .format(reminderList[index].dueDate),
                                title: reminderList[index].title,
                                description: reminderList[index].description,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else if (state is MyTaskErrorState) {
              return Center(
                child: Text(
                  "Something went wrong",
                  style: AppTheme.of(context).title,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  void showTaskBottomSheet(BuildContext context, TaskHiveModel taskModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      builder: (context) => TaskBottomSheet(taskModel: taskModel),
    );
  }

  Widget buildReminderTask(
      {required BuildContext context,
      required String title,
      required String description,
      required String priority,
      required String time,
      required VoidCallback onTap,
      required int index}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animationControllers[index],
          curve: Interval(
            index * 0.1,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 10),
        child: Card(
          elevation: 2,
          color: AppColors.whiteColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 80,
                    decoration: BoxDecoration(
                      color: priority == 'Low'
                          ? Colors.green
                          : priority == 'Medium'
                              ? Colors.amber
                              : Colors.red,
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  AppSizedBox.w8,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: screenWidth - 90,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    title,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTheme.of(context)
                                        .subtitle
                                        .copyWith(
                                            color: AppColors.customGreyColor),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
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
                                      time,
                                      style: AppTheme.of(context)
                                          .bodyText
                                          .copyWith(
                                              color: AppColors.customGreyColor,
                                              fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              '$priority Priority',
                              style: AppTheme.of(context).bodyText.copyWith(
                                  fontSize: 14,
                                  color: priority == 'Low'
                                      ? Colors.green
                                      : priority == 'Medium'
                                          ? Colors.amber
                                          : Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      AppSizedBox.h8,
                      SizedBox(
                        width: screenWidth - 90,
                        child: Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.of(context)
                              .bodyText
                              .copyWith(color: AppColors.customGreyColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
