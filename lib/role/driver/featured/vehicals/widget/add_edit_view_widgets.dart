import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';



/// ---------- UI Helpers ----------

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: CustomText(
      title: title,
      style: CommonStyle.textStyleMedium(size: 18),
    ),
  );
}

Widget card(Widget child) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

Widget documentTile({
  required String title,
  required File? file,
  String? url, // Adding url as a parameter to support network images
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Image section
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade200,
              image:
                  file != null
                      ? DecorationImage(
                        image: FileImage(file),
                        fit: BoxFit.cover,
                      )
                      : url != null && url.isNotEmpty
                      ? DecorationImage(
                        image: NetworkImage(
                          url,
                        ), // Network image when URL is provided
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                file == null && (url == null || url.isEmpty)
                    ? const Icon(
                      Icons.upload_file,
                      color: Colors.grey,
                    ) // Fallback if no image/file/url
                    : null,
          ),
          const SizedBox(width: 12),

          // Title text section
          Expanded(
            child: CustomText(
              title: title,
              style: CommonStyle.textStyleMedium(size: 14),
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    ),
  );
}
