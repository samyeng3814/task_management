import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/constant.dart';
import 'package:my_activity_tracker/core/navigation/navigation.dart';
import 'package:my_activity_tracker/core/theme/themes.dart';
import 'package:my_activity_tracker/core/utils/app_sized_box.dart';
import 'package:my_activity_tracker/features/login_feature/presentation/cubit/login_feature_cubit.dart';
import 'package:my_activity_tracker/features/login_feature/presentation/pages/login_page.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_state.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/pages/add_and_update_task.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/widgets/show_bottom_sheet.dart';
import 'package:my_activity_tracker/features/user/presentation/cubit/user_cubit.dart';

class MyTaskPage extends StatefulWidget {
  const MyTaskPage({super.key});

  @override
  State<MyTaskPage> createState() => _MyTaskPageState();
}

class _MyTaskPageState extends State<MyTaskPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MyTaskCubit>().getTaskList();
    context.read<UserCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LogOutState) {
          pushReplacementContext(context, route: const LoginPage());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          centerTitle: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoadedState) {
                  return CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(state.user.avatarUrl),
                    backgroundColor: AppColors.customGreyColor,
                  );
                } else {
                  return const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(
                      'assets/images/profile_avatar_img.png',
                    ),
                    backgroundColor: AppColors.customGreyColor,
                  );
                }
              },
            ),
          ),
          title: Text(
            'My Tasks',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: () {
                  context.read<LoginCubit>().logout();
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svg/logout_icon.svg'),
                    AppSizedBox.w4,
                    Text(
                      'Log out',
                      style: AppTheme.of(context).bodyText,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          controller: _scrollController,
          children: [
            Column(
              children: [
                Container(
                  color: AppColors.customGreyColor.withOpacity(.1),
                  height: 45,
                  width: size.width,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'My Summary',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    child: BlocBuilder<MyTaskCubit, MyTaskState>(
                        builder: (context, state) {
                      int toDoCount = 0;
                      int inProgressCount = 0;
                      int completedCount = 0;
                      if (state is MyTaskLoadedState) {
                        for (int i = 0; i < state.res.length; i++) {
                          if (state.res[i].status == 'To-Do') {
                            toDoCount++;
                          }
                          if (state.res[i].status == 'In Progress') {
                            inProgressCount++;
                          }
                          if (state.res[i].status == 'Completed') {
                            completedCount++;
                          }
                        }
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          HomeTaskCountCard(
                            size: size,
                            count: toDoCount,
                            desc: 'To Do',
                            image: 'dots.png',
                            color: const Color(0xffff5722),
                          ),
                          HomeTaskCountCard(
                            size: size,
                            count: inProgressCount,
                            desc: 'In Progress',
                            image: 'circles.png',
                            color: const Color(0xff03a9f4),
                          ),
                          HomeTaskCountCard(
                            size: size,
                            count: completedCount,
                            desc: 'Completed',
                            image: 'layers.png',
                            color: const Color(0xff4caf50),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
            Container(
              color: AppColors.customGreyColor.withOpacity(.1),
              height: 45,
              width: size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'My Tasks',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<MyTaskCubit, MyTaskState>(
              builder: (context, state) {
                if (state is MyTaskLoadingState) {
                  return const Center(
                    child: SpinKitFadingCircle(
                      color: AppColors.yellowColor,
                      size: 32,
                    ),
                  );
                } else if (state is MyTaskLoadedState) {
                  if (state.res.isEmpty) {
                    return Center(
                      child: Text(
                        'No task added yet',
                        style: AppTheme.of(context).title,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      key: _listKey,
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: state.res.length,
                      itemBuilder: (context, index) {
                        return buildTaskList(
                          context: context,
                          index: index,
                          onTap: () {
                            showTaskBottomSheet(context, state.res[index]);
                          },
                          priority: state.res[index].priority,
                          time: DateFormat.yMMMMd()
                              .format(state.res[index].dueDate),
                          title: state.res[index].title,
                          description: state.res[index].description,
                        );
                      },
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.blackColor,
          onPressed: () {
            pushContext(
              context,
              route: AddAndUpdateTaskPage(
                pageName: 'Add',
                taskHiveModel: TaskHiveModel(
                  assignedUser: '',
                  description: "",
                  dueDate: DateTime.now(),
                  id: '',
                  priority: 'High',
                  status: 'To-Do',
                  title: '',
                  assignedUserImgUrl: '',
                  isReminded: false,
                ),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: AppColors.whiteColor,
          ),
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
}

Widget buildTaskList(
    {required BuildContext context,
    required String title,
    required String description,
    required String priority,
    required String time,
    required VoidCallback onTap,
    required int index}) {
  Brightness brightness = Theme.of(context).brightness;
  return Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 10),
    child: Card(
      elevation: 0,
      color: brightness == Brightness.dark
          ? AppColors.customGreyColor.withOpacity(.1)
          : priority == 'Low'
              ? const Color.fromRGBO(236, 249, 245, 1)
              : priority == 'Medium'
                  ? const Color.fromRGBO(251, 245, 225, 1)
                  : const Color.fromRGBO(252, 244, 248, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                    .copyWith(color: AppColors.customGreyColor),
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
                                  style: AppTheme.of(context).bodyText.copyWith(
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
  );
}

class HomeTaskCountCard extends StatelessWidget {
  const HomeTaskCountCard({
    super.key,
    required this.size,
    required this.desc,
    required this.count,
    required this.image,
    this.color,
  });

  final Size size;
  final String desc;
  final int? count;
  final String image;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color!.withOpacity(.4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 130,
        width: size.width / 3 - 32,
        child: Stack(
          children: [
            Positioned(
              top: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/$image',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 130,
                  width: size.width / 3 - 32,
                  color: Colors.black87.withOpacity(.3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    desc,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                  Text(
                    '$count',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//"A sturdio apartment in strategic location in Malan Located nearby Univ Muhammadiyah malang. Univ negari Malang and Univ Brawijaya, this is perfect for students and academics"