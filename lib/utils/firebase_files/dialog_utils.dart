import 'package:flutter/material.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';

class DialogUtils {
  static void showLoading(BuildContext context, {String? s,}){
    showDialog(context: context,
    barrierDismissible: false,
     builder:
    (context)=>AlertDialog(
      content:  Row(
         spacing: 20,
        children: [
          CircularProgressIndicator(
            color: AppColors.kText,
            
          ),
          Text("Loading",style: AppStyles.bold16Black,
          )
        ],
      )
      ,
    )
    );
  }
  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }
  static void showMessage(BuildContext context, String message, {String? title, String? posActionName, VoidCallback? posAction}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title ?? 'Notice'),
          content: Text(message),
          actions: [
            if (posActionName != null)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  posAction?.call();
                },
                child: Text(posActionName),
              ),
          ],
        );
      },
    );
  }
   
}