import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';

import '../utils/screen_utils.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Center(
      child: Container(
        width: width * 0.22,
        height: height * 0.045,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.amber, width: 2),
        ),
        child: Row(
          spacing: width*0.025,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.amber, width: 4),
                ),
                child: SvgPicture.asset(
                  AppAssets.lr,
                  fit: BoxFit.fill,
                  height: height * 0.03,
                  width: width * 0.06,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(5.6),
                child: SvgPicture.asset(
                  fit: BoxFit.fill,
                  AppAssets.eg,
                  height: height * 0.03,
                  width: width * 0.06,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
