
import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class SettingItemCard extends StatelessWidget {
  final String? imageIcon;
  final Widget? icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingItemCard({
    super.key,
    this.imageIcon,
    this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  }) : assert(
         imageIcon != null || icon != null,
         'Provide either imageIcon or icon',
       );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (imageIcon != null)
              Image.asset(
                imageIcon!,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              )
            else if (icon != null)
              Container(
                width: 36,
                height: 36,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.yellow.shade100,
                ),
                child: icon,
              ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomText(
                title: title,
                style: CommonStyle.textStyleMedium(size: 16),
              ),
            ),
            trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
