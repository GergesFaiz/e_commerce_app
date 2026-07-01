import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';

import '../utils/app_styles.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  final bool isIcon;

  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  TextStyle? textStyle = AppStyles.regular20Black;
  final Icon? icon;

  CustomElevatedButton({
    this.isIcon = false,
    this.textStyle,
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.amber,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // var height = context.height;

    return ElevatedButton(
      onPressed: () {
        onPressed();
        // Navigator.pushNamed(context, AppRoutes.updateProfileScreen);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
        alignment: Alignment.center,
      ),
      child: isIcon
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                //Icon(,color: AppColors.gray,size: 40,),
                SvgPicture.asset(AppAssets.googleIcon, height: 26, width: 26),

                Text(label, style: AppStyles.regular16Gray),
              ],
            )
          : Text(label, style: textStyle),
    );
  }
}
