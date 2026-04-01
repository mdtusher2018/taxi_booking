import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_booking/core/utilitis/image_utils.dart';
import 'package:taxi_booking/resource/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/common_widget/network_circular_image.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class ImageRow extends StatelessWidget {
  final String title;
  final String url;

  const ImageRow({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: CommonStyle.textStyleSmall(color: Colors.grey)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),

            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: url,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(Icons.broken_image, size: 80),
                  );
                },
                placeholder: (context, url) =>
                    Container(height: 140, color: Colors.grey[300]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: CommonStyle.textStyleSmall(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value, style: CommonStyle.textStyleMedium()),
          ),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SectionCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: CommonStyle.textStyleMedium(size: 16)),
          const Divider(),
          ...children,
        ],
      ),
    );
  }
}

// class ProfileHeader extends ConsumerWidget {
//   final String name;
//   final String phone;
//   final String image;
//   final bool isVerified;
//   final bool iaNotApproved;
//   final VoidCallback? onImagePick;

//   const ProfileHeader({
//     super.key,
//     required this.name,
//     required this.phone,
//     required this.image,
//     required this.isVerified,
//     this.iaNotApproved = false,
//     this.onImagePick,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: (iaNotApproved)
//           ? SizedBox(
//               height: 80,
//               child: Center(
//                 child: CustomText(
//                   title: "Your profile is under admin approval or blocked",
//                 ),
//               ),
//             )
//           : Column(
//               spacing: 4,
//               children: [
//                 Row(
//                   children: [
//                     Stack(
//                       alignment: AlignmentGeometry.bottomRight,
//                       children: [
//                         NetworkCircleAvatar(
//                           key: ValueKey(image), // 👈 important
//                           imageUrl: getFullImagePath(image),
//                           radius: 40,
//                           fallback: Icon(Icons.person, size: 40),
//                         ),
//                         if (onImagePick != null)
//                           InkWell(
//                             onTap: onImagePick,
//                             child: Container(
//                               padding: EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 color: AppColors.btnColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.camera_alt_rounded,
//                                 size: 20,
//                                 color: AppColors.bgColor,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),

//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CustomText(
//                             title: name,
//                             style: CommonStyle.textStyleMedium(size: 18),
//                           ),
//                           const SizedBox(height: 4),
//                           CustomText(
//                             title: phone,
//                             style: CommonStyle.textStyleSmall(
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (isVerified)
//                       Icon(
//                         Icons.verified,
//                         size: 32,
//                         color: Colors.yellow.shade800,
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//     );
//   }
// }

class ProfileHeader extends StatefulWidget {
  final String name;
  final String phone;
  final String image;
  final bool isVerified;
  final ValueChanged<File>? onSaveImage; // optional

  const ProfileHeader({
    super.key,
    required this.name,
    required this.phone,
    required this.image,
    required this.isVerified,
    this.onSaveImage,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? pickedImage;
  bool isSaving = false; // Track loading state
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> saveImage() async {
    if (pickedImage == null || widget.onSaveImage == null) return;

    setState(() => isSaving = true);

    try {
      await Future.delayed(const Duration(seconds: 1)); // simulate save delay
      widget.onSaveImage!(pickedImage!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile image updated successfully!")),
      );
      setState(() {
        pickedImage = null;
      });
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: pickedImage != null
                          ? Image.file(
                              pickedImage!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : NetworkCircleAvatar(
                              key: ValueKey(widget.image),
                              imageUrl: getFullImagePath(widget.image),
                              radius: 40,
                              fallback: Icon(Icons.person, size: 40),
                            ),
                    ),
                  ),
                  if (widget.onSaveImage != null)
                    InkWell(
                      onTap: pickImage,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.btnColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 20,
                          color: AppColors.bgColor,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: widget.name,
                      style: CommonStyle.textStyleMedium(size: 18),
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      title: widget.phone,
                      style: CommonStyle.textStyleSmall(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (widget.isVerified)
                Icon(Icons.verified, size: 32, color: Colors.yellow.shade800),
            ],
          ),
          const SizedBox(height: 16),
          if (pickedImage != null && widget.onSaveImage != null)
            CustomButton(
              title: "Save",
              isLoading: isSaving,
              onTap: isSaving ? null : saveImage,
            ),
        ],
      ),
    );
  }
}
