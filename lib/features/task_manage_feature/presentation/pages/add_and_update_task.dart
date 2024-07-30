import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/navigation/navigation.dart';
import 'package:my_activity_tracker/core/theme/themes.dart';
import 'package:my_activity_tracker/core/utils/app_sized_box.dart';
import 'package:my_activity_tracker/core/utils/button_cubit.dart';
import 'package:my_activity_tracker/core/utils/common_text_field.dart';
import 'package:my_activity_tracker/core/utils/elevated_button.dart';
import 'package:my_activity_tracker/core/utils/utils.dart';
import 'package:my_activity_tracker/core/utils/validation.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_entities.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_cubit.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/cubit/my_task_state.dart';
import 'package:my_activity_tracker/features/user/presentation/cubit/user_cubit.dart';
import 'package:uuid/uuid.dart';

class AddAndUpdateTaskPage extends StatefulWidget {
  final String pageName;
  final TaskHiveModel taskHiveModel;
  const AddAndUpdateTaskPage({
    super.key,
    required this.pageName,
    required this.taskHiveModel,
  });

  @override
  State<AddAndUpdateTaskPage> createState() => _AddAndUpdateTaskPageState();
}

class _AddAndUpdateTaskPageState extends State<AddAndUpdateTaskPage> {
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController =
      TextEditingController(text: DateFormat.yMMMMd().format(DateTime.now()));
  TextEditingController assignedUserController = TextEditingController();

  final FocusNode taskTitleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode dueDateFocusNode = FocusNode();
  final FocusNode assignedUserFocusNode = FocusNode();

  List<String> statuslist = ['To-Do', 'In Progress', 'Completed'];
  List<String> priorityList = ['High', 'Medium', 'Low'];
  DateTime selectedDate = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isSwitched = false;
  String status = 'To-Do';
  String priority = 'High';
  String assignedUserImgUrl = '';

  @override
  void initState() {
    super.initState();

    taskTitleController.text = widget.taskHiveModel.title;
    descriptionController.text = widget.taskHiveModel.description;
    dueDateController.text =
        DateFormat.yMMMMd().format(widget.taskHiveModel.dueDate);
    priority = widget.taskHiveModel.priority;
    status = widget.taskHiveModel.status;
    assignedUserController.text = widget.taskHiveModel.assignedUser;
    isSwitched = widget.taskHiveModel.isReminded;
    assignedUserImgUrl = widget.taskHiveModel.assignedUserImgUrl;
    context.read<UserCubit>().getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0.2,
        automaticallyImplyLeading: false,
        title: Text(
          "${widget.pageName} Task",
          style: AppTheme.of(context).title,
        ),
        leading: IconButton(
          onPressed: () {
            popContext(context);
          },
          icon: SizedBox(
            height: 24,
            width: 24,
            child: SvgPicture.asset(
              'assets/svg/expand_left_arrow.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: BlocListener<MyTaskCubit, MyTaskState>(
        listener: (context, state) {
          if (state is MyTaskAddLoadingState) {
            context.read<ButtonCubit>().setLoading(true);
          } else if (state is MyTaskUpdateLoadingState) {
            context.read<ButtonCubit>().setLoading(true);
          } else if (state is MyTaskAddSuccessState) {
            context.read<ButtonCubit>().setLoading(false);
            popContext(context);
          } else if (state is MyTaskUpdateSuccessState) {
            context.read<ButtonCubit>().setLoading(false);
            popContext(context);
          } else if (state is MyTaskErrorState) {
            if (state.failure is NetworkFailure) {
              Utils.showStatusSnackBar("No internet connection", context);
              context.read<ButtonCubit>().setLoading(false);
            } else {
              Utils.showStatusSnackBar("Something went wrong", context);
              context.read<ButtonCubit>().setLoading(false);
            }
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Title",
                                style: AppTheme.of(context).subtitle.copyWith(
                                      color:
                                          AppColors.blackColor.withOpacity(0.8),
                                    ),
                              ),
                              AppSizedBox.h8,
                              CustomTextField(
                                obsureText: false,
                                autofocus: false,
                                controller: taskTitleController,
                                isBorderEnabled: true,
                                focusNode: taskTitleFocusNode,
                                onFieldSubmitted: (val) {
                                  FocusScope.of(context)
                                      .requestFocus(descriptionFocusNode);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter title';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Due date",
                                style: AppTheme.of(context).subtitle.copyWith(
                                      color:
                                          AppColors.blackColor.withOpacity(0.8),
                                    ),
                              ),
                              AppSizedBox.h8,
                              CustomTextField(
                                onTap: () async {
                                  await showDatePicker(
                                          context: context,
                                          initialDate: selectedDate,
                                          firstDate: DateTime(2015, 8),
                                          lastDate: DateTime(2101))
                                      .then(
                                    (picked) {
                                      if (picked != null) {
                                        dueDateController.text =
                                            DateFormat.yMMMMd().format(picked);
                                        setState(() {
                                          selectedDate = picked;
                                        });
                                      } else {
                                        debugPrint(
                                            'No date selected or dialog closed with null value.');
                                      }
                                    },
                                  );
                                },
                                readOnly: true,
                                obsureText: false,
                                autofocus: false,
                                controller: dueDateController,
                                suffix: const Icon(Icons.arrow_drop_down),
                                isBorderEnabled: true,
                                inputFormatters:
                                    TextFieldValidator.nameValidator,
                                focusNode: dueDateFocusNode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please pick due date';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status",
                                      style: AppTheme.of(context)
                                          .subtitle
                                          .copyWith(
                                            color: AppColors.blackColor
                                                .withOpacity(0.8),
                                          ),
                                    ),
                                    AppSizedBox.h8,
                                    buildCustomDropdown(
                                      context: context,
                                      items: statuslist,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          status = newValue!;
                                        });
                                      },
                                      value: status,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AppSizedBox.w12,
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Priority",
                                      style: AppTheme.of(context)
                                          .subtitle
                                          .copyWith(
                                            color: AppColors.blackColor
                                                .withOpacity(0.8),
                                          ),
                                    ),
                                    AppSizedBox.h8,
                                    buildCustomDropdown(
                                      context: context,
                                      items: priorityList,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          priority = newValue!;
                                        });
                                      },
                                      value: priority,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Set task reminder',
                                style: AppTheme.of(context).subtitle.copyWith(
                                      color:
                                          AppColors.blackColor.withOpacity(0.8),
                                    ),
                              ),
                              Switch.adaptive(
                                onChanged: (value) {
                                  setState(() {
                                    isSwitched = value;
                                  });
                                },
                                value: isSwitched,
                                activeColor: AppColors.whiteColor,
                                activeTrackColor: AppColors.blackColor,
                                inactiveThumbColor:
                                    AppColors.blackColor.withOpacity(0.8),
                                inactiveTrackColor:
                                    AppColors.customGreyColor.withOpacity(0.6),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Assigned User",
                                style: AppTheme.of(context).subtitle.copyWith(
                                      color:
                                          AppColors.blackColor.withOpacity(0.8),
                                    ),
                              ),
                              AppSizedBox.h8,
                              CustomTextField(
                                onTap: () {
                                  showUserListDialog(context);
                                },
                                suffix: const Icon(Icons.arrow_drop_down),
                                obsureText: false,
                                autofocus: false,
                                readOnly: true,
                                controller: assignedUserController,
                                isBorderEnabled: true,
                                inputFormatters:
                                    TextFieldValidator.nameValidator,
                                focusNode: assignedUserFocusNode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select user';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: AppTheme.of(context).subtitle.copyWith(
                                      color:
                                          AppColors.blackColor.withOpacity(0.8),
                                    ),
                              ),
                              AppSizedBox.h8,
                              CustomTextField(
                                maxLines: 5,
                                obsureText: false,
                                autofocus: false,
                                controller: descriptionController,
                                isBorderEnabled: true,
                                focusNode: descriptionFocusNode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter description';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        AppSizedBox.h12,
                        CustomButton(
                          text: widget.pageName,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final taskId = const Uuid().v4();
                              if (widget.pageName == "Add") {
                                context.read<MyTaskCubit>().addTask(
                                      TaskEntity(
                                        assignedUser:
                                            assignedUserController.text,
                                        description: descriptionController.text,
                                        dueDate: selectedDate,
                                        id: taskId,
                                        priority: priority,
                                        status: status,
                                        title: taskTitleController.text,
                                        isReminded: isSwitched,
                                        assignedUserImgUrl: assignedUserImgUrl,
                                      ),
                                    );
                              }
                              if (widget.pageName == "Update") {
                                context.read<MyTaskCubit>().updateTask(
                                      TaskEntity(
                                        assignedUser:
                                            assignedUserController.text,
                                        description: descriptionController.text,
                                        dueDate: selectedDate,
                                        id: widget.taskHiveModel.id,
                                        priority: priority,
                                        status: status,
                                        title: taskTitleController.text,
                                        isReminded: isSwitched,
                                        assignedUserImgUrl: assignedUserImgUrl,
                                      ),
                                    );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomDropdown({
    required BuildContext context,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.2,
          color: AppColors.textFieldBorderColor,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void showUserListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          title: Text(
            'Select User',
            style: AppTheme.of(context).title,
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UsersLoadedState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundImage:
                              NetworkImage(state.list[index].avatar),
                        ),
                        title: Text(
                          '${state.list[index].firstName} ${state.list[index].lastName}',
                          style: AppTheme.of(context)
                              .bodyText
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          state.list[index].email,
                          style: AppTheme.of(context)
                              .bodyText
                              .copyWith(fontSize: 14),
                        ),
                        onTap: () {
                          popContext(context, state.list[index]);
                        },
                      );
                    },
                  );
                } else if (state is UserErrorState) {
                  return Text(
                    'Something went wrong',
                    style: AppTheme.of(context).bodyText,
                  );
                } else if (state is UserLoadingState) {
                  return const CupertinoActivityIndicator(
                    radius: 26,
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                popContext(context);
              },
              child: Text(
                'Close',
                style: AppTheme.of(context).bodyText,
              ),
            ),
          ],
        );
      },
    ).then(
      (selectedUser) {
        if (selectedUser != null) {
          assignedUserController.text =
              '${selectedUser.firstName} ${selectedUser.lastName}';
          assignedUserImgUrl = selectedUser.avatar;
        } else {
          debugPrint('No user selected or dialog closed with null value.');
        }
      },
    );
  }
}
