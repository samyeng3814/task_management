import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_activity_tracker/core/utils/utils.dart';

Widget customCachedWebImage(
    {required String imageUrl,
    double width = 100,
    double height = 100,
    fit = BoxFit.cover,
    BoxFit errorImageFit = BoxFit.scaleDown}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    useOldImageOnUrlChange: true,
    placeholder: (context, url) => FittedBox(
      fit: BoxFit.scaleDown,
      child: Utils.spikeLoader(
        context,
        opacity: 0.0,
      ),
    ),
    errorWidget: (context, url, error) => SvgPicture.asset(
      'assets/svg/profile_icon.svg',
      fit: BoxFit.contain,
    ),
    width: width,
    height: height,
    fit: fit,
  );
}
