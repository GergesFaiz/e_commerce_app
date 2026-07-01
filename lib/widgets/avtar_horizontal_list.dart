import 'package:flutter/material.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/screen_utils.dart';

class AvtarHorizontalList extends StatefulWidget {
  
  final Function(int) onAvatarSelected;

  const AvtarHorizontalList({super.key, required this.onAvatarSelected});

  @override
  State<AvtarHorizontalList> createState() => _AvtarHorizontalListState();
}

class _AvtarHorizontalListState extends State<AvtarHorizontalList> {
  final List<String> avatarImages = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
    AppAssets.avatar10,
  ];

int? selectedAvatar;
  @override
  Widget build(BuildContext context) {
  double screenwidth=context.width;
    double baseRadius = screenwidth* 0.14; 
  double selectedRadius = baseRadius * 1.2;
    return SizedBox(
      height: screenwidth*.43,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: avatarImages.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedAvatar == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAvatar = index;
              });
              
              widget.onAvatarSelected(index);
            },
            child:/* Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.amber : Colors.transparent,
                  // خليها لون شيك يليق مع الموفيز
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(avatarImages[index]),
              ),
            ),*/
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin:  EdgeInsetsDirectional.symmetric(horizontal: screenwidth*.02),
              transform: isSelected?Matrix4.identity().scaled(1.1):Matrix4.identity(),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: isSelected?selectedRadius : baseRadius,
                //45:35,
                backgroundColor: isSelected?AppColors.amber:AppColors.gray,
                child: CircleAvatar(
                  radius: isSelected?(selectedRadius-3):(baseRadius-2),
                  backgroundImage: AssetImage(avatarImages[index]),
                ),
              ),
            )
          );
        },
      ),
    );
  }
}
