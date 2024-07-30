// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:my_activity_tracker/core/utils/regex_validation.dart';

class LoginAuthEntity extends Equatable {
  final String token;
  final String id;

  const LoginAuthEntity(this.token, this.id);

  @override
  List<Object?> get props => [];
}

class LoginCredentialEntity extends Equatable {
  String email;
  String password;

  LoginCredentialEntity({required this.email, required this.password});

  bool checkUserIdIsEmpty() => email.isEmpty;

  bool checkUserPasswordIsEmpty() => password.isEmpty;

  bool checkUserIdIsEmail() => RegExValidation.emailRegExp.hasMatch(
        email,
      );
  @override
  List<Object?> get props => [];
}
