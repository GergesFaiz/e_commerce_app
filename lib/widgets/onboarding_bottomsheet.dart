import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/widgets/custom_elevatedbutton.dart';

class OnboardingBottomsheet extends StatelessWidget {
  final String bottomSheetTitle;
  final String bottomSheetDiscribtion;
  final String buttonText;
  final VoidCallback navigatornext;
  final VoidCallback navigatorback;
  final bool isFirstPage;

  const OnboardingBottomsheet({
    super.key,
    required this.bottomSheetTitle,
    required this.bottomSheetDiscribtion,
    required this.buttonText,
    this.isFirstPage = false,
    required this.navigatornext,
    required this.navigatorback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 5,
        children: [
          Text(
            bottomSheetTitle,
            style: AppStyles.bold24White,
            textAlign: TextAlign.center,
          ),
          Text(
            bottomSheetDiscribtion,
            style: AppStyles.bold20White,
            textAlign: TextAlign.center,
          ),

          CustomElevatedButton(
            label: buttonText,
            textStyle: AppStyles.bold20black,
            onPressed: () {
              if (buttonText == "Next") {
                navigatornext();
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
              }
            },
          ),
          if (isFirstPage == false)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(15),
                  side: BorderSide(color: AppColors.amber),
                ),
              ),
              onPressed: () {
                navigatorback();
              },
              child: Text(
                'Back',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.amber,
                  fontSize: 20,
                  fontWeight: .w400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
