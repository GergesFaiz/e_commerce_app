import 'package:flutter/material.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';

import '../utils/app_assets.dart';

class CustomTextField extends StatefulWidget {
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final String hintText;

   const CustomTextField({
    super.key,
    required this.textInputType,
    required this.textInputAction,
    required this.controller,
    this.validator,
    this.isPassword = false,
    required this.hintText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isShowPassword;

  @override
  void initState() {
    super.initState();

    isShowPassword = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      enableSuggestions: false,
      cursorColor: AppColors.white,
      cursorRadius: Radius.circular(16),
      keyboardType: widget.isPassword
          ? widget.textInputType
          : TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: AppStyles.regular16white,
      obscureText: isShowPassword,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppStyles.regular16white,

        filled: true,
        fillColor: AppColors.gray,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
                icon: Icon(
                  isShowPassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.white,
                ),
              )
            : null,
        prefixIcon: widget.isPassword
            ? Icon(Icons.lock, color: AppColors.white,size: 26,)
            : //(Icon( Icons.email,color: AppColors.white)),
              (widget.hintText == "Email")
            ?  ImageIcon(
                AssetImage(AppAssets.emailIcon),
                size: 31,
                color: AppColors.white,
              )
            : (widget.hintText == "Name" || widget.hintText == "John Safwat")
            ?  Icon(Icons.person, color: AppColors.white)
            : (widget.hintText == "Phone Number" ||
                  widget.hintText == "01200000000")
            ?  Icon(Icons.phone, color: AppColors.white)
            : null,


        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.blackColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.blackColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.red, width: 1),
        ),
      ),
    );
  }
}
