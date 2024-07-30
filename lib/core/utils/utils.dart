import 'package:flutter/Material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_activity_tracker/core/colors.dart';
import 'package:my_activity_tracker/core/theme/themes.dart';

class Utils {
  static Widget spikeLoader(BuildContext context,
      {double opacity = 0,
      Color color = Colors.transparent,
      double size = 26}) {
    return Container(
      color: Colors.white.withOpacity(opacity),
      child: SpinKitThreeBounce(
        color: color == Colors.transparent ? AppColors.yellowColor : color,
        size: size,
      ),
    );
  }

  static DateTime decodeDateTime(String dateTimeString) {
    return DateTime.parse(dateTimeString);
  }

  static String encodeDateTime(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  static showStatusSnackBar(String statusMsg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: AppColors.blackColor.withOpacity(0.5),
        behavior: SnackBarBehavior.floating,
        content: Text(
          statusMsg,
          style: AppTheme.of(context)
              .bodyText
              .copyWith(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
