import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class CustomRadioTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final Widget? leading;
  final Widget? title;
  final String titleText;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final VoidCallback? onTap; // <-- optional onTap

  const CustomRadioTile({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.leading,
    this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.spacing = 12,
    required this.titleText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          onChanged(value);
        }
      },
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading!, SizedBox(width: spacing)],
            Expanded(
              child:
                  title ??
                  Text(titleText, style: CommonStyle.textStyleMedium(size: 16)),
            ),
            Radio<T>(
              value: value,
              groupValue: groupValue,
              activeColor: AppColors.mainColor,
              onChanged: (newVal) {
                if (newVal != null) {
                  onChanged(newVal);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
