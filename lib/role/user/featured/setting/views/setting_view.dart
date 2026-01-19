import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/role/common/chat/views/message_view.dart';
import 'package:taxi_booking/role/user/featured/payment/views/payment_view.dart';
import 'package:taxi_booking/role/user/featured/setting/views/edit_profile_view.dart';

import 'package:taxi_booking/resource/app_images/app_images.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_switch_widget.dart';

import '../../../../../resource/common_dialog/custom_dialog.dart';
import '../../../../../resource/utilitis/common_style.dart';
import '../widget/setting_item_card.dart';

class UserSettingView extends StatefulWidget {
  const UserSettingView({super.key});

  @override
  State<UserSettingView> createState() => _UserSettingViewState();
}

class _UserSettingViewState extends State<UserSettingView> {
  bool isPromoEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Setting', leading: SizedBox()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              /// Pull handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              /// User Info
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileView()),
                  );
                },
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=3',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Jenny Wilson",
                          style: CommonStyle.textStyleMedium(size: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "+00 (207) 555-0119",
                          style: CommonStyle.textStyleSmall(
                            size: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// Bronze & Points
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AppImages.bronzeIcon, width: 32, height: 32),
                      const SizedBox(width: 8),
                      Text(
                        "Bronze",
                        style: CommonStyle.textStyleMedium(size: 14),
                      ),
                    ],
                  ),
                  const Text(
                    "63.2 Points",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const Divider(height: 30),

              /// Payment
              SettingItemCard(
                icon: AppImages.paymentIcon,
                title: "Payment",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PaymentView()),
                  );
                },
              ),

              /// Customer Support
              SettingItemCard(
                icon: AppImages.customerAndSupport,
                title: "Customer Support",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MessageView(reciverId: "support_id"),
                    ),
                  );
                },
              ),

              /// Security
              SettingItemCard(icon: AppImages.security, title: "Security"),

              /// Promo Toggle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppImages.promoCode, width: 32, height: 32),
                        const SizedBox(width: 12),
                        Text(
                          "Promo Code Info",
                          style: CommonStyle.textStyleMedium(size: 14),
                        ),
                      ],
                    ),
                    CustomSwitchWidget(
                      value: isPromoEnabled,
                      scale: 0.7,
                      activeColor: AppColors.mainColor,
                      onChanged: (value) {
                        setState(() {
                          isPromoEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const Divider(height: 10),

              /// Logout
              SettingItemCard(
                icon: AppImages.logout,
                title: "Log out",
                onTap: () {
                  CustomAlertDialog().customAlert(
                    context: context,
                    title: 'Want to Log out?',
                    message: 'Are you sure you want to log out?',
                    NegativebuttonText: 'Cancel',
                    PositivvebuttonText: "Log out",
                    onPositiveButtonPressed: () => Navigator.pop(context),
                    onNegativeButtonPressed: () => Navigator.pop(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
