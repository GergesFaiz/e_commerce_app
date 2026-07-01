import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_validator.dart';
import 'package:movies/utils/firebase_files/auth_function.dart';
import 'package:movies/utils/firebase_files/dialog_utils.dart';
import 'package:movies/widgets/custom_elevatedbutton.dart';
import 'package:movies/widgets/custom_text_field.dart';
import 'package:movies/widgets/language_switch.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/back_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController confirmPasswordController;
  late TextEditingController phoneController;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    confirmPasswordController = TextEditingController();
    phoneController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  final List<String> avatarImages = [
    AppAssets.avatar2,
    AppAssets.avatar7,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar1,
    AppAssets.avatar10,
    AppAssets.avatar9,
    AppAssets.avatar8,
  ];

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    String chosenAvatar = '';
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: BackAppBar(title: 'Register'),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Column(
              spacing: height * 0.01,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    height: height * 0.18,
                    viewportFraction: 0.37,
                    enableInfiniteScroll: true,
                    enlargeFactor: 0.4,
                  ),
                  items: avatarImages.map((path) {
                    setState(() {
                      chosenAvatar = path;
                    });
                    return Image.asset(path, fit: BoxFit.cover);
                  }).toList(),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: height * 0.02,
                  children: [
                    Text(
                      'Avatar',
                      style: AppStyles.regular16white,
                      // TextStyle(color: AppColors.white, fontSize: 12),**ابقي استخدمي AppStyles 🫡🫡*******
                      textAlign: TextAlign.center,
                    ),
                    CustomTextField(
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: nameController,
                      hintText: //"Name",
                      AppLocalizations.of(context)!.name,
                      validator: AppValidator
                          .validateName, // nice clean code جميله   قوي التقسيمه دي 🫡🫡
                    ),
                    CustomTextField(
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      hintText:// "Email",
                      AppLocalizations.of(context)!.email,
                      validator: AppValidator.validateEmail,
                    ),
                    CustomTextField(
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: passwordController,
                      hintText: //"Password",
                      AppLocalizations.of(context)!.password,
                      isPassword: true,
                      validator: AppValidator.validatePassword,
                    ),
                    CustomTextField(
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: confirmPasswordController,
                      hintText:// "Confirm Password",
                      AppLocalizations.of(context)!.confirmPassword,
                      isPassword: true,
                      validator: (value) =>
                          AppValidator.validateConfirmPassword(
                            value,
                            passwordController.text,
                          ), //عظمة 🫡🫡
                    ),
                    CustomTextField(
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: phoneController,
                      hintText:// "Phone Number",
                      AppLocalizations.of(context)!.phoneNumber,
                      validator: AppValidator.validatePhone, //عظمة 🫡🫡
                    ),
                    CustomElevatedButton(
                      label: "Create Account",
                      textStyle: AppStyles.bold20black,
                      onPressed: () async {
                        print("Start Registration");
                        if (formKey.currentState!.validate()) {
                          DialogUtils.showLoading(s: 'LOADING...', context);
                          try {
                            String? error =
                                await FirebaseFunctions.registerUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                                  avatar: chosenAvatar,
                                ); //عظمة 🫡🫡

                            DialogUtils.hideLoading(
                              context,
                            ); // 🫡 مش فاهمها قوي هحتاجك تعرفاني

                            if (error == null) {
                              DialogUtils.showMessage(
                                context ,AppLocalizations.of(context)!.createAccount,
                               // 'Account created successfully!',
                                posActionName: 'Ok',
                                posAction: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.homeScreen,
                                  );
                                },
                              );
                            } else {
                              DialogUtils.showMessage(
                                context,
                                error,
                                title: "Error",
                              );
                            }
                          } catch (e) {
                            DialogUtils.hideLoading(context);
                            DialogUtils.showMessage(
                              context,
                              e.toString(),
                              title:AppLocalizations.of(context)!.systemError,
                              // "System Error",
                            );
                          }
                        }
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text( AppLocalizations.of(context)!.alreadyHaveAccount,
                          //'Already Have Account ? ',
                          style: AppStyles.bold14White,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.loginScreen,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.login,
                            //'Login',
                            style: AppStyles.bold14White.copyWith(
                              color: AppColors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(child:   LanguageSwitch(),)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
