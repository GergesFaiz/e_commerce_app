import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MainErrorWidget extends StatelessWidget {
  String massage;
  VoidCallback onPressed;

  MainErrorWidget({super.key, required this.massage, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(massage, style: TextStyle(color: Colors.white)),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            "try again",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
