import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'custom_size.dart';

class CommonStyle {
  static final borderRadiusSmall = BorderRadius.circular(
    CustomSize.radiusSmall,
  );
  static final borderRadiusMedium = BorderRadius.circular(
    CustomSize.radiusMedium,
  );
  static final borderRadiusLarge = BorderRadius.circular(
    CustomSize.radiusLarge,
  );

  static TextStyle textStyleSmall({
    Color? color,
    double? size,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: size ?? CustomSize.fontSmall,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Colors.black,
    );
  }

  static TextStyle textStyleMedium({
    Color? color,
    double? size,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: size ?? CustomSize.fontMedium,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? Colors.black,
    );
  }

  static TextStyle textStyleLarge({
    Color? color,
    double? size,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: size ?? CustomSize.fontLarge,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Colors.black,
    );
  }

  // decoration
  static BoxDecoration cardDecoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadiusMedium,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
      ],
    );
  }

  static BoxDecoration shadowDecoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadiusMedium,
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.3),
          blurRadius: 1,
          spreadRadius: 1,
        ),
      ],
    );
  }

  static InputDecoration inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(
        vertical: CustomSize.paddingSmall,
        horizontal: CustomSize.paddingMedium,
      ),
      border: OutlineInputBorder(
        borderRadius: borderRadiusSmall,
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadiusSmall,
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadiusSmall,
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }

  // padding
  static const paddingAllSmall = EdgeInsets.all(CustomSize.paddingSmall);
  static const paddingAllMedium = EdgeInsets.all(CustomSize.paddingMedium);
  static const paddingAllLarge = EdgeInsets.all(CustomSize.paddingLarge);

  static const paddingHorizontalSmall = EdgeInsets.symmetric(
    horizontal: CustomSize.paddingSmall,
  );
  static const paddingHorizontalMedium = EdgeInsets.symmetric(
    horizontal: CustomSize.paddingMedium,
  );
  static const paddingHorizontalLarge = EdgeInsets.symmetric(
    horizontal: CustomSize.paddingLarge,
  );

  static const paddingVerticalSmall = EdgeInsets.symmetric(
    vertical: CustomSize.paddingSmall,
  );
  static const paddingVerticalMedium = EdgeInsets.symmetric(
    vertical: CustomSize.paddingMedium,
  );
  static const paddingVerticalLarge = EdgeInsets.symmetric(
    vertical: CustomSize.paddingLarge,
  );

  static const paddingTopSmall = EdgeInsets.only(top: CustomSize.paddingSmall);
  static const paddingBottomMedium = EdgeInsets.only(
    bottom: CustomSize.paddingMedium,
  );
  static const paddingLeftLarge = EdgeInsets.only(
    left: CustomSize.paddingLarge,
  );

  static const commonLoadingColor = [AppColors.mainColor, Color(0xff673AB7)];
}
