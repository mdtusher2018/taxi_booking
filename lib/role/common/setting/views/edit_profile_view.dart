import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/role/common/setting/model/profile_response.dart';
import 'package:taxi_booking/role/common/setting/widget/profile_details_widgets.dart';

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
              image: identityUploads?.selfie ?? "", // Null-safe
              phone: user.phone,
            ),
            const SizedBox(height: 24),

            // Personal Information Section
            SectionCard(
              title: "Personal Information",
              children: [
                InfoRow("Full Name", user.fullName),
                if (user.email != null) InfoRow("Email", user.email!),
                InfoRow("Phone", user.phone),
                if (user.dateOfBirth != null)
                  InfoRow(
                    "Date of Birth",
                    user.dateOfBirth.toString().split("T").first,
                  ),
                if (user.nationalIdNumber != null)
                  InfoRow("National ID", user.nationalIdNumber!),
              ],
            ),

            // Address Section
            if (address != null)
              SectionCard(
                title: "Address",
                children: [
                  InfoRow("Street", address.street),
                  InfoRow("Postal Code", address.postalCode),
                  InfoRow("City", address.city),
                  InfoRow("Country", address.country),
                ],
              ),

            // Driver License Section (Only for drivers)
            if (user.driverLicenseNumber != null)
              SectionCard(
                title: "Driver License",
                children: [
                  InfoRow("License Number", user.driverLicenseNumber ?? ""),
                  const SizedBox(height: 12),
                  if (licenseUploads?.driverLicenseFront != null)
                    ImageRow(
                      title: "License Front",
                      url: licenseUploads!.driverLicenseFront,
                    ),
                  if (licenseUploads?.driverLicenseBack != null)
                    ImageRow(
                      title: "License Back",
                      url: licenseUploads!.driverLicenseBack,
                    ),
                  if (licenseUploads?.driverPermitFront != null)
                    ImageRow(
                      title: "Permit Front",
                      url: licenseUploads!.driverPermitFront,
                    ),
                  if (licenseUploads?.driverPermitBack != null)
                    ImageRow(
                      title: "Permit Back",
                      url: licenseUploads!.driverPermitBack,
                    ),
                ],
              ),

            // Identity Verification Section (Only for users who uploaded ID)
            if (identityUploads?.selfie != null)
              SectionCard(
                title: "Identity Verification",
                children: [
                  ImageRow(title: "Selfie", url: identityUploads!.selfie),
                  ImageRow(title: "ID Front", url: identityUploads.idFront),
                  ImageRow(title: "ID Back", url: identityUploads.idBack),
                ],
              ),

            if (data.role == "WithCar" && user.currentLocation != null)
              SectionCard(
                title: "Current Location",
                children: [
                  InfoRow("Location Address", user.currentLocation!.address),
                  // You can also show the location on a map if needed.
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
