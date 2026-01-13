import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';

class CustomCheckBox extends StatelessWidget {
  final bool isChecked;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final double borderWidth;
  final Function(bool) onChanged;

  const CustomCheckBox({
    Key? key,
    required this.isChecked,
    this.size = 20.0,
    this.activeColor = AppColors.mainColor,
    this.inactiveColor = Colors.transparent,
    this.borderWidth = 1.5,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isChecked);
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainColor, width: borderWidth),
          borderRadius: BorderRadius.circular(4),
          color: isChecked ? activeColor : inactiveColor,
        ),
        child:
            isChecked
                ? Icon(Icons.check, size: size * 0.6, color: Colors.white)
                : null,
      ),
    );
  }
}
