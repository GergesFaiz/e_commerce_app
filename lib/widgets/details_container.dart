import 'package:flutter/material.dart';
import 'package:movies/utils/app_styles.dart';

class DetailsContainer extends StatelessWidget {
  final String text;
  final bool isicon;
  final IconData icon;

  const DetailsContainer({
    super.key,
    required this.text,
    this.isicon = true,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isicon
              ? Icon(
                  //Icons.star
                  icon,
                  color: Colors.amber,
                  size: 30,
                )
              : SizedBox(width: 8),
          Text(
            text,
            //  movie.rating?.toStringAsFixed(1) ?? '0',
            style: AppStyles.regular16white,
          ),
        ],
      ),
    );
  }
}
