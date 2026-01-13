// import 'package:flutter/material.dart';

// class SplashController {
//   // Animation states
//   var logoScale = 0.0;
//   var logoOpacity = 0.0;
//   var logoAlignment = Alignment.center;
//   var textOpacity = 0.0;
//   var buttonsOpacity = 0.0;
//   var logoSize = (MediaQuery.sizeOf(context).width * 0.6);

//   @override
//   void onInit() {
//     super.onInit();
//     startSplashAnimation();
//   }

//   void startSplashAnimation() async {
//     // Phase 1: Logo appears in center with scale and fade animation
//     logoOpacity.value = 1.0;
//     logoScale.value = 1.0;

//     // Wait for logo to settle
//     await Future.delayed(const Duration(milliseconds: 1200));

//     // Phase 2: Logo moves up and shrinks
//     logoAlignment.value = const Alignment(0, -0.4);
//     logoSize.value = MediaQuery.sizeOf(context).width * 0.35;

//     // Wait for logo movement to complete
//     await Future.delayed(const Duration(milliseconds: 600));

//     // Phase 3: Text fades in below the logo
//     textOpacity.value = 1.0;

//     // Wait for text animation
//     await Future.delayed(const Duration(milliseconds: 800));

//     // Phase 4: Buttons slide up from bottom
//     buttonsOpacity.value = 1.0;
//   }

//   @override
//   void onClose() {
//     super.onClose();
//   }
// }
