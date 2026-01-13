import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class UploadTaxiImageWidget extends StatelessWidget {
  UploadTaxiImageWidget({super.key});

  final List<XFile> selectedImages = <XFile>[];

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      selectedImages.addAll(images);
    }
  }

  void deleteImage(int index) {
    selectedImages.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // your previous form fields…
        const SizedBox(height: 10),
        Text('Attach Taxi Image', style: CommonStyle.textStyleMedium(size: 16)),
        const SizedBox(height: 5),

        // ===== Upload button =====
        GestureDetector(
          onTap: () => pickImages(),
          child: Container(
            height: MediaQuery.sizeOf(context).height / 8,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_download_outlined,
                  color: Colors.grey,
                  size: 50,
                ),
                Text(
                  'Upload Taxi Images',
                  style: CommonStyle.textStyleSmall(size: 12),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // ===== Show selected images =====
        selectedImages.isEmpty
            ? const SizedBox()
            : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final img = selectedImages[index];
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(img.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => deleteImage(index),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      ],
    );
  }
}
