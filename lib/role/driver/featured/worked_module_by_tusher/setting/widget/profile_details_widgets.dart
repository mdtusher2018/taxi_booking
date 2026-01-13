import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/common_widget/network_circular_image.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class ImageRow extends StatelessWidget {
  final String title;
  final String url;

  const ImageRow({required this.title, required this.url});

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
            child: CachedNetworkImage(
              imageUrl: url,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) =>
                      Container(height: 140, color: Colors.grey[300]),
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

  const InfoRow(this.label, this.value);

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

  const SectionCard({required this.title, required this.children});

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

class ProfileHeader extends StatelessWidget {
  final String name;
  final String phone;
  final String image;
  final bool isVerified;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.phone,
    required this.image,
    required this.isVerified,
  });

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
      child: Row(
        children: [
          NetworkCircleAvatar(
            imageUrl: image,
            radius: 40,
            fallback: Icon(Icons.person, size: 40),
          ),

          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: name,
                  style: CommonStyle.textStyleMedium(size: 18),
                ),
                const SizedBox(height: 4),
                CustomText(
                  title: phone,
                  style: CommonStyle.textStyleSmall(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isVerified)
            Icon(Icons.verified, size: 32, color: Colors.yellow.shade800),
        ],
      ),
    );
  }
}
