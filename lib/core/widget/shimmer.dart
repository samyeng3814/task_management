import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:my_activity_tracker/core/colors.dart';

class ShimmerContainer extends StatefulWidget {
  final double height;
  final double? width;
  const ShimmerContainer({
    super.key,
    required this.height,
    this.width,
  });

  @override
  State<ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<ShimmerContainer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.whiteColor,
      highlightColor: const Color.fromARGB(255, 228, 228, 228),
      child: Card(
        // elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(padding: const EdgeInsets.all(20), child: Container()),
      ),
    );
  }
}
