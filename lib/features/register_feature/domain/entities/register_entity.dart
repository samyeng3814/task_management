// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:my_activity_tracker/core/utils/regex_validation.dart';

class RegisterEntity extends Equatable {
  final String token;
  final String id;

  const RegisterEntity(this.token, this.id);

  @override
  List<Object?> get props => [];
}

class RegisterCredentialEntity extends Equatable {
  String email;
  String password;
  String firstName;
  String lastName;

  RegisterCredentialEntity({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  bool checkUserIdIsEmpty() => email.isEmpty;

  bool checkUserPasswordIsEmpty() => password.isEmpty;

  bool checkUserIdIsEmail() => RegExValidation.emailRegExp.hasMatch(
        email,
      );

  @override
  List<Object?> get props => [];
}
