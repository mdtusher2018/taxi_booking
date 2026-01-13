// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? fontSize;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool forceMaterialTransparency;
  final bool? automaticallyImplyLeading;
  final List<Widget>? actions;
  final Widget? leading;
  final double? toolbarHeight;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.fontSize,
    this.centerTitle = true,
    this.backgroundColor = Colors.white,
    this.forceMaterialTransparency = true,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading,
    this.toolbarHeight,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight),
       super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      backgroundColor: backgroundColor,
      title: Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: fontSize ?? 18,
          fontWeight: FontWeight.w500,
          color: AppColors.black33,
        ),
      ),
      centerTitle: centerTitle,
      flexibleSpace: Container(color: Colors.transparent),
      actions: actions,
      leading:
          leading ??
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              // padding: EdgeInsets.zero,
              // width: 20,
              // height: 20,
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   shape: BoxShape.rectangle
              // ),
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.blackColor,
                size: 22,
              ),
            ),
          ),
      elevation: forceMaterialTransparency ? 0 : null,
    );
  }
}
