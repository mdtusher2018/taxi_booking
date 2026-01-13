import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class CustomTextFieldWithLabel extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final String? subText;
  final TextInputType? keyboardType;
  const CustomTextFieldWithLabel({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.onTap,
    this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label, style: CommonStyle.textStyleMedium(size: 16)),
        SizedBox(height: 5),
        CustomTextField(
          hint: hint,
          controller: controller,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          keyboardType: keyboardType,
          onTap: onTap,
        ),
        if (subText != null) CustomText(title: subText!),
      ],
    );
  }
}
