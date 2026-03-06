import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/services/storage/storage_key.dart';
import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DriverSplashView extends ConsumerStatefulWidget {
  const DriverSplashView({super.key});

  @override
  ConsumerState<DriverSplashView> createState() => _DriverSplashViewState();
}

class _DriverSplashViewState extends ConsumerState<DriverSplashView> {
  // Animation states
  double logoScale = 0.0;
  double logoOpacity = 0.0;
  Alignment logoAlignment = Alignment.center;
  double textOpacity = 0.0;
  double buttonsOpacity = 0.0;
  double logoSize = 0.6;

  @override
  void initState() {
    super.initState();
    startSplashAnimation();
  }

  void startSplashAnimation() async {
    // Phase 1: Logo appears in center with scale and fade animation
    setState(() {
      logoOpacity = 1.0;
      logoScale = 1.0;
    });

    // Wait for logo to settle
    await Future.delayed(const Duration(milliseconds: 1200));

    // Phase 2: Logo moves up and shrinks
    setState(() {
      logoAlignment = const Alignment(0, -0.4);
      logoSize = MediaQuery.of(context).size.width * 0.35;
    });

    // Wait for logo movement to complete
    await Future.delayed(const Duration(milliseconds: 600));

    // Phase 3: Text fades in below the logo
    setState(() {
      textOpacity = 1.0;
    });

    // Wait for text animation
    await Future.delayed(const Duration(milliseconds: 800));
    final token = await ref
        .read(localStorageServiceProvider)
        .readKey(StorageKey.accessToken);
    if (token != null) {
      context.go(DriverAppRoutes.driverRoot);
    } else {
      setState(() {
        buttonsOpacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              // Main content area
              Expanded(
                child: Stack(
                  children: [
                    // Animated Logo
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
                              width: screenWidth * 0.3,
                              height: screenWidth * 0.3,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Animated Text
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: const CustomText(
                                  textAlign: TextAlign.center,
                                  title:
                                      'Drive with TilX.\nEarn extra money driving.',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  letterSpacing: 0.5,
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

              // Bottom section with buttons
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: buttonsOpacity,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 1000),
                  offset: buttonsOpacity == 1.0
                      ? Offset.zero
                      : const Offset(0, 1),
                  curve: Curves.easeOutCubic,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.04,
                    ),
                    child: Column(
                      children: [
                        // Decorative divider
                        Container(
                          width: screenWidth * 0.2,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.amber.shade600,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // Log in button
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.065,
                          child: ElevatedButton(
                            onPressed: () {
                              context.push(
                                DriverAppRoutes.authenticationView,
                                extra: {"isLogin": true},
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade600,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            child: const Text('Log in'),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        // Sign up button
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.065,
                          child: ElevatedButton(
                            onPressed: () {
                              context.push(
                                DriverAppRoutes.authenticationView,
                                extra: {"isLogin": false},
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
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
      ),
    );
  }
}
