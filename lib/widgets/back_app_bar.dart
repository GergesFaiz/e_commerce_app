import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
   const BackAppBar({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(


      elevation: 0,
      title: Text(
        title,
        style: AppStyles.bold16White.copyWith(color: AppColors.amber),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.amber),
    );
  }


  @override Size get preferredSize =>  Size.fromHeight(54);
}
