import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class SettingItemCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;
  const SettingItemCard({super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(icon, width: 32, height: 32,),
      title: CustomText(title: title, style: CommonStyle.textStyleMedium(size: 14),),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
