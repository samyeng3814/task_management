import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/theme/themes.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool? obsureText;
  final Function? onTapOutside;
  final int maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final bool? readOnly;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool? isBorderEnabled;
  final bool? autofocus;
  final Function(String)? onFieldSubmitted;
  final bool isLabelEnabled;
  final Function()? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.onTapOutside,
    this.obsureText = false,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.isBorderEnabled = false,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.isLabelEnabled = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        readOnly: readOnly!,
        onTap: onTap,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        style: const TextStyle(
          fontSize: 14,
        ),
        obscureText: obsureText!,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: autofocus!,
        focusNode: focusNode,
        controller: controller,
        cursorColor: AppColors.textColor,
        onFieldSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatters,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: prefix,
          suffixIcon: suffix,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          disabledBorder: InputBorder.none,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          fillColor: AppColors.textFieldFillColor,
          filled: true,
          labelText: isLabelEnabled ? hintText : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.blackColor,
              width: 1.2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.textFieldBorderColor,
              width: 1.2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppColors.textFieldBorderColor,
              width: 1.2,
            ),
          ),
          hintText: hintText,
          hintStyle: AppTheme.of(context).bodyText.copyWith(
                color: AppColors.hintTextColor.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: isBorderEnabled!
                ? BorderSide(
                    color: AppColors.textFieldBorderColor,
                    width: 1.2,
                  )
                : BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }
}
