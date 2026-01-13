import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_switch_widget.dart';

import '../../../../../resource/utilitis/common_style.dart';
import '../../../../../resource/utilitis/custom_toast.dart';
import 'give_tips_sheet.dart';

class GiveReviewSheet extends StatefulWidget {
  const GiveReviewSheet({super.key});

  @override
  State<GiveReviewSheet> createState() => _GiveReviewSheetState();
}

class _GiveReviewSheetState extends State<GiveReviewSheet> {
  double _rating = 3.0;
  bool _shareMessage = true;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Driver info
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=3",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Arlene McCoy",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Driver", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const Divider(height: 20),

              // Thank you text
              const Center(
                child: Text(
                  "Thank you! 😍",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  "Please rate your trip",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),

              // Star rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 24,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder:
                        (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "(${_rating.toStringAsFixed(1)})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Message box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Hey Arlene! Write your message here ...",
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Toggle
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      "Share your message with other taxi passenger.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  CustomSwitchWidget(
                    scale: 0.8,
                    value: _shareMessage,
                    onChanged: (val) {
                      setState(() {
                        _shareMessage = val;
                      });
                    },
                    activeColor: AppColors.mainColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Next button
              CustomButton(
                title: 'Submit Review',
                onTap: () {
                  Navigator.pop(context);
                  // Handle next action here
                  CustomToast.showToast(
                    message: "Review submitted successfully",
                  );
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const GiveTipsSheet(),
                  );
                },
                widget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Submit Review",
                      style: CommonStyle.textStyleSmall(size: 16),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
