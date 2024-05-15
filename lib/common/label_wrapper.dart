import 'package:flutter/material.dart';

class LabelWrapper extends StatelessWidget {
  final Text text;
  final Widget? child;
  final double spaceBetween;
  final double? widgetSize;
  const LabelWrapper(
      {super.key,
      required this.text,
      this.child,
      this.widgetSize,
      this.spaceBetween = 5.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text,
        SizedBox(height: spaceBetween),
        if (child != null)
          SizedBox(
            height: widgetSize,
            child: child!,
          ),
      ],
    );
  }
}
