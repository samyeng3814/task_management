import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/theme/themes.dart';
import 'package:my_activity_tracker/core/utils/button_cubit.dart';
import 'package:my_activity_tracker/core/utils/utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color? buttonColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonCubit, bool>(
      builder: (context, isLoading) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
            backgroundColor: buttonColor ?? Colors.black,
            elevation: 1,
            padding: const EdgeInsets.all(16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
          ),
          onPressed: onPressed,
          child: isLoading
              ? Utils.spikeLoader(context)
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      text,
                      style: AppTheme.of(context).subtitle.copyWith(
                            color: AppColors.whiteColor,
                          ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
