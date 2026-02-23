// ArrivingCard
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/routes/user_app_routes.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';

class RideEndSheet extends ConsumerStatefulWidget {
  final VoidCallback? onCancel;

  const RideEndSheet({super.key, this.onCancel});

  @override
  ConsumerState<RideEndSheet> createState() => _ArrivingCardState();
}

class _ArrivingCardState extends ConsumerState<RideEndSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, size: 90, color: AppColors.btnColor),
          const SizedBox(height: 24),
          CustomText(
            title: "Ride Completed",
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 8),

          CustomText(
            title:
                "Thank you for riding with us. We hope you had a comfortable and pleasant journey. We look forward to serving you again!",
            fontSize: 14,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          CustomButton(
            title: "Back to Home",
            onTap: () {
              context.go(UserAppRoutes.rootView);
            },
          ),
        ],
      ),
    );
  }
}
