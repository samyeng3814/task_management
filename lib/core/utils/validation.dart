import 'package:flutter/services.dart';

class TextFieldValidator {
  static List<TextInputFormatter> emailValidator = [
    FilteringTextInputFormatter.deny(' '),
    FilteringTextInputFormatter.allow(
      RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      ),
    ),
  ];

  static List<TextInputFormatter> nameValidator = [
    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
  ];
}
