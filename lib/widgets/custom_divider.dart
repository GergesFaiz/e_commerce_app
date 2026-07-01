 import 'package:flutter/material.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';

import '../utils/screen_utils.dart';


class CustomDivider extends StatelessWidget 
  {
  const CustomDivider({super.key});

   
 


  @override
  Widget build(BuildContext context) {
    var width = context.width;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:width * 0.15 ),
      child: Row(
        children: [

      Expanded(
        child: Divider(
          thickness: 1,
          color: AppColors.amber,
          endIndent: 11.2,
        ),
      ),

      Text(
        "OR",
        style:AppStyles.medium15Amber
      ),

      Expanded(
        child: Divider(
          thickness: 1,
          color:AppColors.amber,
          indent: 11.2,
        ),
      ),]),
    )
   ;
  }}