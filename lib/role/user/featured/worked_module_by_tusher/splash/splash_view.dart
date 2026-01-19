import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/core/routes/user_app_routes.dart';

class UserSplashView extends StatefulWidget {
  const UserSplashView({super.key});

  @override
  State<UserSplashView> createState() => _UserSplashViewState();
}

class _UserSplashViewState extends State<UserSplashView>
    with SingleTickerProviderStateMixin {
  // Animation states
  double logoScale = 0.0;
  double logoOpacity = 0.0;
  Alignment logoAlignment = Alignment.center;
  double textOpacity = 0.0;
  double buttonsOpacity = 0.0;
  double logoSize = 0.0;

  @override
  void initState() {
    super.initState();

    final screenWidth =
        WidgetsBinding
            .instance
            .platformDispatcher
            .views
            .first
            .physicalSize
            .width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    logoSize = screenWidth * 0.6;

    startSplashAnimation(screenWidth);
  }

  Future<void> startSplashAnimation(double screenWidth) async {
    // Phase 1
    setState(() {
      logoOpacity = 1.0;
      logoScale = 1.0;
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    // Phase 2
    setState(() {
      logoAlignment = const Alignment(0, -0.4);
      logoSize = screenWidth * 0.35;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    // Phase 3
    setState(() {
      textOpacity = 1.0;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    // Phase 4
    setState(() {
      buttonsOpacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// MAIN CONTENT
            Expanded(
              child: Stack(
                children: [
                  /// LOGO
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                    alignment: logoAlignment,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: logoOpacity,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 600),
                        scale: logoScale,
                        curve: Curves.elasticOut,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutCubic,
                          width: logoSize,
                          height: logoSize,
                          child: Image.asset(
                            AppImages.splashLogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// TEXT
                  Align(
                    alignment: const Alignment(0, 0.1),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 800),
                      opacity: textOpacity,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 800),
                        offset: textOpacity == 1.0
                            ? Offset.zero
                            : const Offset(0, 0.5),
                        curve: Curves.easeOutCubic,
                        child: const CustomText(
                          textAlign: TextAlign.center,
                          title: 'Drive with TilX.\nEarn extra money driving.',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// BOTTOM BUTTONS
            AnimatedOpacity(
              duration: const Duration(milliseconds: 1000),
              opacity: buttonsOpacity,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 1000),
                offset: buttonsOpacity == 1.0
                    ? Offset.zero
                    : const Offset(0, 1),
                curve: Curves.easeOutCubic,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.08,
                    vertical: height * 0.04,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: width * 0.2,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.amber.shade600,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      SizedBox(height: height * 0.04),

                      /// LOGIN
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.065,
                        child: ElevatedButton(
                          onPressed: () {
                            context.go(
                              UserAppRoutes.authenticationView,
                              extra: {'isLogin': true},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Log in'),
                        ),
                      ),

                      SizedBox(height: height * 0.015),

                      /// SIGN UP
                      SizedBox(
                        width: double.infinity,
                        height: height * 0.065,
                        child: ElevatedButton(
                          onPressed: () {
                            context.go(
                              UserAppRoutes.authenticationView,
                              extra: {'isLogin': false},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Sign up'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
