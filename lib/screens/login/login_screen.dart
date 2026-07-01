import 'package:flutter/material.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/widgets/custom_divider.dart';
import 'package:movies/widgets/custom_elevatedbutton.dart';
import 'package:movies/widgets/custom_text_field.dart';
import 'package:movies/widgets/language_switch.dart';

import '../../utils/firebase_files/auth_function.dart';
import '../../utils/firebase_files/dialog_utils.dart';
import '../../utils/screen_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: height * 0.02,
                children: [
                  SizedBox(
                    height: height * 0.28,
                    width: width * 0.28,
                    child: Image.asset(AppAssets.splashImage),
                  ),
                  CustomTextField(
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    hintText: local.email,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return local.emailRequired;
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    hintText: local.password,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return local.passwordRequired;
                      }
                      if (value.length < 6) return local.passwordTooShort;
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPasswordScreen,
                      ),
                      child: Text(
                          local.forgetPassword, style: AppStyles.medium14Amber),
                    ),
                  ),

                  // Login button
                  CustomElevatedButton(
                    label: local.login,
                    textStyle: AppStyles.bold20Gray,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        DialogUtils.showLoading(s: local.loading, context);
                        try {
                          String? error =
                          await FirebaseFunctions.signInWithEmailAndPassword(
                            emailAddress: emailController.text.trim(),
                            password: passwordController.text,
                          );
                          DialogUtils.hideLoading(context);

                          if (error == null) {
                            DialogUtils.showMessage(
                              context,
                              local.loginSuccess,
                              posActionName: local.ok,
                              posAction: () =>
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.homeScreen,
                                  ),
                            );
                          } else {
                            DialogUtils.showMessage(
                                context, error, title: local.error);
                          }
                        } catch (e) {
                          DialogUtils.hideLoading(context);
                          DialogUtils.showMessage(
                              context, e.toString(), title: local.systemError);
                        }
                      }
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(local.dontHaveAccount,
                          style: AppStyles.medium14White),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(
                                context, AppRoutes.registerScreen),
                        child: Text(
                          local.createOne,
                          style: AppStyles.medium14Amber.copyWith(
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),

                  CustomDivider(),

                  // Google Sign-In button
                  CustomElevatedButton(
                    label: local.loginWithGoogle,
                    isIcon: true,
                    textStyle: AppStyles.regular16black,
                    onPressed: () async {
                      DialogUtils.showLoading(s: local.loading, context);
                      try {
                        String? error = await FirebaseFunctions
                            .signInWithGoogle();
                        DialogUtils.hideLoading(context);

                        if (error == null) {
                          Navigator.pushReplacementNamed(context,
                              AppRoutes.homeScreen);
                        } else if (error != 'cancelled') {
                          DialogUtils.showMessage(
                              context, error, title: local.error);
                        }
                      } catch (e) {
                        DialogUtils.hideLoading(context);
                        DialogUtils.showMessage(context, e.toString(),
                            title: local.systemError);
                      }
                    },
                  ),

                  LanguageSwitch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
