import 'package:flutter/material.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/widgets/custom_elevatedbutton.dart';
import 'package:movies/widgets/onboarding_bottomsheet.dart';
import 'package:movies/widgets/onboarding_data.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController pageController = PageController();
  int currentpage = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: onboardingPages.length,
      onPageChanged: (index) {
        setState(() => currentpage = index);
      },

      itemBuilder: (context, index) {
        final data = onboardingPages[index];
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(data.image, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      data.gradientColor.withOpacity(0.6),
                      data.gradientColor,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
              (index == 0)
                  ? firstPagt(data)
                  : Align(
                      alignment: AlignmentGeometry.bottomCenter,
                      child: OnboardingBottomsheet(
                        bottomSheetTitle: data.title,
                        bottomSheetDiscribtion: data.description,
                        buttonText: data.buttonText,
                        isFirstPage: index == 1,
                        navigatornext: () => navigate("next"),
                        navigatorback: () => navigate("back"),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  void navigate(String direction) {
    if (direction == 'next') {
      if (currentpage == onboardingPages.length - 1) {
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      } else {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else if (direction == 'back') {
      pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget firstPagt(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20,
        children: [
          const Spacer(flex: 2),
          Text(
            data.title,
            style: AppStyles.medium36white,
            textAlign: TextAlign.center,
          ),
          Text(
            data.description,
            style: AppStyles.bold20White,
            textAlign: TextAlign.center,
          ),
          CustomElevatedButton(
            label: data.buttonText,
            textStyle: AppStyles.bold20black,
            onPressed: () => navigate("next"),
          ),
          //  const Spacer(),
        ],
      ),
    );
  }
}
