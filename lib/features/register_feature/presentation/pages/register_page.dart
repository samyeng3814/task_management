import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:my_activity_tracker/core/utils/validation.dart';
import 'package:my_activity_tracker/features/login_feature/presentation/pages/login_page.dart';
import 'package:my_activity_tracker/features/register_feature/domain/entities/register_entity.dart';
import 'package:my_activity_tracker/features/register_feature/presentation/cubit/Register_feature_state.dart';
import 'package:my_activity_tracker/features/register_feature/presentation/cubit/register_feature_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailIdFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  bool passwordVisibility = true;
  bool confirmPasswordVisibility = true;
  RegisterCredentialEntity registerEntity = RegisterCredentialEntity(
      email: "", password: "", firstName: "", lastName: "");

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  String? _validate(String key) {
    switch (key) {
      case "email":
        if (registerEntity.checkUserIdIsEmpty()) {
          return "Email ID required";
        } else if (!registerEntity.checkUserIdIsEmail()) {
          return "Invalid Email ID";
        } else {
          return null;
        }
      default:
        if (registerEntity.checkUserPasswordIsEmpty()) {
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
      context.read<RegisterFeatureCubit>().validateUserRegister(registerEntity);
    }
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
          "Register",
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
      body: BlocListener<RegisterFeatureCubit, RegisterFeatureState>(
        listener: (context, state) {
          if (state is RegisterLoadingState) {
            context.read<ButtonCubit>().setLoading(true);
          } else if (state is RegisterLoadedState) {
            context.read<ButtonCubit>().setLoading(false);
            pushContext(context, route: const LoginPage());
            Utils.showStatusSnackBar('User successfully registerd', context);
          } else if (state is RegisterErrorState) {
            if (state.failure is NetworkFailure) {
              Utils.showStatusSnackBar("No internet connection", context);
              context.read<ButtonCubit>().setLoading(false);
            } else {
              Utils.showStatusSnackBar('User can\'t be register. Try with another email', context);
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
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "First Name",
                                      style: AppTheme.of(context).bodyText,
                                    ),
                                    AppSizedBox.h8,
                                    CustomTextField(
                                      obsureText: false,
                                      autofocus: false,
                                      controller: firstNameController,
                                      isBorderEnabled: true,
                                      inputFormatters:
                                          TextFieldValidator.nameValidator,
                                      focusNode: firstNameFocusNode,
                                      onFieldSubmitted: (val) {
                                        FocusScope.of(context)
                                            .requestFocus(lastNameFocusNode);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AppSizedBox.w16,
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Last Name",
                                      style: AppTheme.of(context).bodyText,
                                    ),
                                    AppSizedBox.h8,
                                    CustomTextField(
                                      obsureText: false,
                                      autofocus: false,
                                      controller: lastNameController,
                                      isBorderEnabled: true,
                                      inputFormatters:
                                          TextFieldValidator.nameValidator,
                                      focusNode: lastNameFocusNode,
                                      onFieldSubmitted: (val) {
                                        FocusScope.of(context)
                                            .requestFocus(emailIdFocusNode);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email ID",
                                style: AppTheme.of(context).bodyText,
                              ),
                              AppSizedBox.h8,
                              CustomTextField(
                                obsureText: false,
                                autofocus: false,
                                controller: emailController,
                                hintText: "abc@gmail.com",
                                isBorderEnabled: true,
                                validator: (value) {
                                  registerEntity.email = value!.trim();
                                  return _validate("email");
                                },
                                focusNode: emailIdFocusNode,
                                onFieldSubmitted: (val) {
                                  FocusScope.of(context)
                                      .requestFocus(passwordFocusNode);
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
                                "Password",
                                style: AppTheme.of(context).bodyText,
                              ),
                              AppSizedBox.h8,
                              CustomTextField(
                                obsureText: passwordVisibility,
                                controller: passwordController,
                                hintText: "********",
                                isBorderEnabled: true,
                                focusNode: passwordFocusNode,
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      passwordVisibility = !passwordVisibility;
                                    });
                                  },
                                  child: Icon(
                                    passwordVisibility
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: AppColors.textFieldVisibleIconColor,
                                  ),
                                ),
                                onFieldSubmitted: (val) {
                                  FocusScope.of(context)
                                      .requestFocus(confirmPasswordFocusNode);
                                },
                                validator: (value) {
                                  registerEntity.password = value!;
                                  return _validate("password");
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
                                "Confirm Password",
                                style: AppTheme.of(context).bodyText,
                              ),
                              AppSizedBox.h8,
                              CustomTextField(
                                obsureText: confirmPasswordVisibility,
                                controller: confirmPasswordController,
                                hintText: "********",
                                isBorderEnabled: true,
                                focusNode: confirmPasswordFocusNode,
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      confirmPasswordVisibility =
                                          !confirmPasswordVisibility;
                                    });
                                  },
                                  child: Icon(
                                    passwordVisibility
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                    color: AppColors.textFieldVisibleIconColor,
                                  ),
                                ),
                                onFieldSubmitted: (val) {
                                  FocusScope.of(context).unfocus();
                                },
                                validator: (value) {
                                  if(passwordController.text == value){
                                    registerEntity.password = value!;
                                    return _validate("password");
                                  }else{
                                    return "Confirm password doesn't match";
                                  }

                                },
                              ),
                            ],
                          ),
                        ),
                        AppSizedBox.h12,
                        CustomButton(
                          text: 'Sign Up',
                          onPressed: () {
                            onSubmit();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Have an account?",
                                  style: AppTheme.of(context).bodyText),
                              GestureDetector(
                                onTap: () {
                                  pushContext(context,
                                      route: const LoginPage());
                                },
                                child: Text(
                                  ' Sign In',
                                  style: AppTheme.of(context).bodyText.copyWith(
                                        fontWeight: FontWeight.bold,
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
    );
  }
}
