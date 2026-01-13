import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/setting/model/profile_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/setting/widget/profile_details_widgets.dart';

class ProfileView extends StatelessWidget {
  final ProfileData data;
  const ProfileView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final user = data.user;
    final address = user.address;
    final licenseUploads = user.driverLicenseUploads;
    final identityUploads = user.identityUploads;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: "Profile Details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileHeader(
              name: user.fullName,
              isVerified: user.status == "APPROVED",
              image: identityUploads.selfie,
              phone: user.phone,
            ),
            const SizedBox(height: 24),

            SectionCard(
              title: "Personal Information",
              children: [
                InfoRow("Full Name", user.fullName),
                InfoRow("Email", user.email),
                InfoRow("Phone", user.phone),
                InfoRow(
                  "Date of Birth",
                  user.dateOfBirth.toString().split("T").first,
                ),
                InfoRow("National ID", user.personalId),
              ],
            ),

            SectionCard(
              title: "Address",
              children: [
                InfoRow("Street", address.street),
                InfoRow("Postal Code", address.postalCode),
                InfoRow("City", address.city),
                InfoRow("Country", address.country),
              ],
            ),

            SectionCard(
              title: "Driver License",
              children: [
                InfoRow("License Number", user.driverLicenseNumber),
                const SizedBox(height: 12),
                ImageRow(
                  title: "License Front",
                  url: licenseUploads.driverLicenseFront,
                ),
                ImageRow(
                  title: "License Back",
                  url: licenseUploads.driverLicenseBack,
                ),
                ImageRow(
                  title: "Permit Front",
                  url: licenseUploads.driverPermitFront,
                ),
                ImageRow(
                  title: "Permit Back",
                  url: licenseUploads.driverPermitBack,
                ),
              ],
            ),

            SectionCard(
              title: "Identity Verification",
              children: [
                ImageRow(title: "Selfie", url: identityUploads.selfie),
                ImageRow(title: "ID Front", url: identityUploads.idFront),
                ImageRow(title: "ID Back", url: identityUploads.idBack),
              ],
            ),

            const SizedBox(height: 24),
            CustomButton(
              title: "Back to Setting",
              onTap: () {
                context.pop();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
