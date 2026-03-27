

import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';

class CustomSwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveThumbColor;
  final Color inactiveTrackColor;
  final double scale;

  const CustomSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColors.mainColor,
    this.inactiveThumbColor = Colors.grey,
    this.inactiveTrackColor = Colors.black12,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: activeColor,
        inactiveThumbColor: inactiveThumbColor,
        inactiveTrackColor: inactiveTrackColor,
      ),
    );
  }
}
