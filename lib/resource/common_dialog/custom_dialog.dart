// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import '../common_widget/custom_button.dart';
import '../utilitis/custom_loader.dart';

class CustomAlertDialog {
  Future<void> customAlert({
    required BuildContext context,
    required String title,
    required String message,
    required String NegativebuttonText,
    required String PositivvebuttonText,
    required VoidCallback onPositiveButtonPressed,
    required VoidCallback onNegativeButtonPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 14), // Replacing heightBox14 with SizedBox
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: PositivvebuttonText,
                      paddingVertical: 10,
                      fontSize: 14,
                      onTap: onPositiveButtonPressed,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      title: NegativebuttonText,
                      paddingVertical: 10,
                      buttonColor: Colors.transparent,
                      titleColor: AppColors.darkPink,
                      border: Border.all(color: AppColors.darkPink),
                      fontSize: 14,
                      onTap: onNegativeButtonPressed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeleteAccountDialog(
    BuildContext context,
    VoidCallback onPositiveButtonPressed,
    bool isLoading,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Delete Account",
      transitionDuration: Duration(milliseconds: 300), // Animation duration
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
                SizedBox(height: 20),
                Text(
                  "Delete Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    decoration: TextDecoration.none,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Are you sure you want to delete your account? This action cannot be undone.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                isLoading
                    ? CustomLoaderWidget()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: onPositiveButtonPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeInOut.transform(animation.value) - 1;
        return Transform.translate(
          offset: Offset(0, curvedValue * -50),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
    );
  }

  void showLoaderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }

  // void showFullScreenImageDialog({
  //   required BuildContext context,
  //   String? imageUrl,
  //   File? imageFile,
  // }) {
  //   if (imageUrl == null && imageFile == null) return;
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return ShowFullScreenImageDialog(
  //         imageUrl: imageUrl,
  //         imageFile: imageFile,
  //       );
  //     },
  //   );
  // }
}
