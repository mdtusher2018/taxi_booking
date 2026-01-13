import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';


class UploadKjoresedImage extends StatelessWidget {
  UploadKjoresedImage({super.key});

  final List<XFile> selectedKjoresedImages = <XFile>[];

  Future<void> pickKjoresedImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      selectedKjoresedImages.addAll(images);
    }
  }

  void deleteKjoresedImage(int index) {
    selectedKjoresedImages.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // your previous form fields…
        const SizedBox(height: 10),
        Text(
          'Attach kjøreseddel Image',
          style: CommonStyle.textStyleMedium(size: 16),
        ),
        const SizedBox(height: 5),

        // ===== Upload button =====
        GestureDetector(
          onTap: () => pickKjoresedImages(),
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
                  'Upload kjøreseddel Image',
                  style: CommonStyle.textStyleSmall(size: 12),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // ===== Show selected images =====
        selectedKjoresedImages.isEmpty
            ? const SizedBox()
            : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedKjoresedImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final img = selectedKjoresedImages[index];
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
                        onTap: () => deleteKjoresedImage(index),
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
