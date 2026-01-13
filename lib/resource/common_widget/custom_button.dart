
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';

// round_button.dart

class CustomButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final bool isLoading;
  final double width;
  final double paddingVertical;
  final double borderRadius;
  final Color? buttonColor;
  final double fontSize;
  final BoxBorder? border;
  final Color? titleColor;
  final Widget? widget;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.width = double.infinity,
    this.paddingVertical = 12.0,
    this.borderRadius = 9.0,
    this.buttonColor = AppColors.btnColor,
    this.border,
    this.titleColor = Colors.black,
    this.widget,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          // gradient: LinearGradient(
          //     colors: [Color(0xff4F7E65), Color(0xff002B14)],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter
          // ),
        ),
        width: width,
        padding: EdgeInsets.symmetric(vertical: paddingVertical),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : widget ??
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
      ),
    );
  }
}

// isLoading == true ? Center(child: const CircularProgressIndicator(color: Colors.green,)) :
