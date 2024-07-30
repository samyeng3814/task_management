import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/constant.dart';
import 'package:my_activity_tracker/core/failure.dart';
import 'package:my_activity_tracker/core/navigation/navigation.dart';
import 'package:my_activity_tracker/core/theme/themes.dart';
import 'package:my_activity_tracker/core/utils/app_sized_box.dart';
import 'package:my_activity_tracker/core/utils/button_cubit.dart';
import 'package:my_activity_tracker/core/utils/common_text_field.dart';
import 'package:my_activity_tracker/core/utils/elevated_button.dart';
import 'package:my_activity_tracker/core/utils/utils.dart';
import 'package:my_activity_tracker/features/login_feature/domain/entities/login_auth_entity.dart';
import 'package:my_activity_tracker/features/login_feature/presentation/cubit/login_feature_cubit.dart';
import 'package:my_activity_tracker/features/register_feature/presentation/pages/register_page.dart';
import 'package:my_activity_tracker/features/task_manage_feature/presentation/pages/home_page.dart';
import 'package:my_activity_tracker/features/user/data/models/user_hive_model.dart';
import 'package:my_activity_tracker/features/user/presentation/cubit/user_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController =
      TextEditingController();
  TextEditingController passwordController =
      TextEditingController();
  final FocusNode emailIdFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool passwordVisibility = true;
  LoginCredentialEntity loginEntity = LoginCredentialEntity(
      email: "", password: "");
  String userToken = '';
  final GlobalKey<FormState> _formKey = GlobalKey();

  String? _validate(String key) {
    switch (key) {
      case "email":
        if (loginEntity.checkUserIdIsEmpty()) {
          return "Email ID required";
        } else if (!loginEntity.checkUserIdIsEmail()) {
          return "Invalid Email ID";
        } else {
          return null;
        }
      default:
        if (loginEntity.checkUserPasswordIsEmpty()) {
          return "Password required";
        } else {
          return null;
        }
    }
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<LoginCubit>().validateUserLogin(loginEntity);
    }
  }

  void storeUser(UserHiveModel user) async {
    final userBox = Hive.box<UserHiveModel>('userBox');
    await userBox.put('currentUser', user);
  }

  @override
  void initState() {
    context.read<LoginCubit>().emitLoginInitialState();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            context.read<ButtonCubit>().setLoading(true);
          } else if (state is LoginLoadedState) {
            userToken = state.res.token;
            context.read<UserCubit>().getUserList();
          } else if (state is LoginErrorState) {
            if (state.failure is NetworkFailure) {
              context.read<ButtonCubit>().setLoading(false);
              Utils.showStatusSnackBar("No internet connection !!", context);
            } else {
              context.read<ButtonCubit>().setLoading(false);
              Utils.showStatusSnackBar('Something went wrong', context);
            }
          }
        },
        child: SafeArea(
          child: BlocListener<UserCubit, UserState>(
            listener: (context, state) {
              if (state is UsersLoadedState) {
                var user = state.list.firstWhere(
                    (getUser) => getUser.email == loginEntity.email);
                storeUser(
                  UserHiveModel(
                    avatarUrl: user.avatar,
                    email: user.email,
                    id: user.id,
                    token: userToken,
                    username: '${user.firstName} ${user.lastName}',
                  ),
                );
                context.read<ButtonCubit>().setLoading(false);
                Utils.showStatusSnackBar('Login successfull', context);
                pushReplacementContext(context, route: const HomePage());
              }
            },
            child: Stack(
              children: [
                Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                    child: SingleChildScrollView(
                      child: Container(
                        width: screenWidth - (screenWidth * 0.12),
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(0.8, -0.37),
                            end: const Alignment(-0.8, 0.37),
                            colors: [
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.7),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(22.0),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 800),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: 'Task ',
                                    style: AppTheme.of(context).title.copyWith(
                                        color: AppColors.yellowColor),
                                    children: [
                                      TextSpan(
                                          text: 'Tracker',
                                          style: AppTheme.of(context).title),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.04,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Email ID",
                                              style:
                                                  AppTheme.of(context).bodyText,
                                            ),
                                            AppSizedBox.h8,
                                            CustomTextField(
                                              obsureText: false,
                                              autofocus: false,
                                              onTapOutside: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              controller: emailController,
                                              hintText: "abc@gmail.com",
                                              isBorderEnabled: true,
                                              validator: (value) {
                                                loginEntity.email =
                                                    value!.trim();
                                                return _validate("email");
                                              },
                                              focusNode: emailIdFocusNode,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Password",
                                              style:
                                                  AppTheme.of(context).bodyText,
                                            ),
                                            AppSizedBox.h8,
                                            CustomTextField(
                                              obsureText: passwordVisibility,
                                              controller: passwordController,
                                              onTapOutside: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              hintText: "********",
                                              isBorderEnabled: true,
                                              focusNode: passwordFocusNode,
                                              suffix: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    passwordVisibility =
                                                        !passwordVisibility;
                                                  });
                                                },
                                                child: Icon(
                                                  passwordVisibility
                                                      ? Icons
                                                          .visibility_off_rounded
                                                      : Icons
                                                          .visibility_rounded,
                                                  color: AppColors
                                                      .textFieldVisibleIconColor,
                                                ),
                                              ),
                                              validator: (value) {
                                                loginEntity.password = value!;
                                                return _validate("password");
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      AppSizedBox.h12,
                                      CustomButton(
                                        text: "Login",
                                        onPressed: () {
                                          onSubmit();
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 24.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Doesn't have an account?",
                                                style: AppTheme.of(context)
                                                    .bodyText),
                                            GestureDetector(
                                              onTap: () {
                                                pushContext(context,
                                                    route:
                                                        const RegisterPage());
                                              },
                                              child: Text(
                                                ' Sign Up',
                                                style: AppTheme.of(context)
                                                    .bodyText
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
