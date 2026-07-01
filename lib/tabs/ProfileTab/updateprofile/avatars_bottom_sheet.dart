import 'package:flutter/material.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/screen_utils.dart';

class AvatarsBottomSheet extends StatefulWidget {
   const AvatarsBottomSheet({
    super.key,
    required this.onAvatarSelected,
    required this.initialAvatar,
  });

  final Function(int) onAvatarSelected;
  final int initialAvatar;

  @override
  State<AvatarsBottomSheet> createState() => _AvatarsBottomSheetState();
}

class _AvatarsBottomSheetState extends State<AvatarsBottomSheet> {
  late int selectedAvatar;

  final List<String> avatarImages = [
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
      ];

  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.initialAvatar;
  }

  @override
  Widget build(BuildContext context) {
    //var height = context.height;
    var width = context.width;
    return Container(
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics:  NeverScrollableScrollPhysics(),
        itemCount: avatarImages.length,
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, i) {
          final selected = i == selectedAvatar;
          return GestureDetector(
            onTap: () {
              setState(() => selectedAvatar = i);
              widget.onAvatarSelected(i);
              Future.delayed(
                 Duration(milliseconds: 500),
                    () => Navigator.pop(context),
              );
            },
            child: AnimatedContainer(
              duration:  Duration(milliseconds: 200),

              decoration: BoxDecoration(
                color:selected ? AppColors.amber.withAlpha(90) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: AppColors.amber ,
                  width: 2,
                ),
              ),
              child: SizedBox(
                width: width*0.2,
                child: Image.asset(avatarImages[i],),
              ),
            ),
          );
        },
      ),
    );
  }
}