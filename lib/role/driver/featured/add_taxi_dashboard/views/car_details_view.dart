// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_network_image.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';

class CarDetailsView extends StatelessWidget {
  CarDetailsView({super.key});

  bool pulledTaxi = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Car Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Car Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: CustomNetworkImage(
                      imageUrl:
                          "https://img.freepik.com/free-psd/black-isolated-car_23-2151852894.jpg?semt=ais_hybrid&w=740&q=80",
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Corolla Hatchback",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Corolla Allion 25",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pulled Taxi Switch
            SwitchListTile(
              value: pulledTaxi,
              onChanged: (val) => pulledTaxi = val,
              activeColor: AppColors.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.grey),
              ),
              title: Text(
                "Pulled Taxi",
                style: CommonStyle.textStyleMedium(size: 16),
              ),
            ),
            const SizedBox(height: 8),

            // Details Only If Pulled Taxi ON
            pulledTaxi
                ? Column(
                  children: [
                    buildDetailCard("Name", "Brooklyn Simmons"),
                    buildDetailCard("Em ID", "tiix_abc_123_23"),
                    buildDetailCard("Phone", "(219) 555-0114"),
                    buildDetailCard("Email", "michael.mitc@example.com"),
                    buildDetailCard(
                      "Address",
                      "6391 Elgin St. Celina, Delaware 10299",
                    ),
                    buildDetailCard("Driving licence", "abc_123_23"),
                    buildDetailCard("ID No.", "125 265 658 985"),

                    // kjøreseddel expandable
                    ExpansionTile(
                      title: Text(
                        "kjøreseddel",
                        style: CommonStyle.textStyleMedium(size: 16),
                      ),
                      initiallyExpanded: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      children: [
                        buildDetailCard("Driver Character", "Good"),
                        buildDetailCard("Driver Health", "Good"),
                        buildDetailCard("Driver Age", "21 year"),
                        // GestureDetector for image dialog
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (_) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    insetPadding: const EdgeInsets.all(16),
                                    child: Stack(
                                      children: [
                                        // Image Container
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                title: 'kjøreseddel Image',
                                                style:
                                                    CommonStyle.textStyleMedium(
                                                      size: 16,
                                                    ),
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  "https://img.freepik.com/free-psd/black-isolated-car_23-2151852894.jpg?semt=ais_hybrid&w=740&q=80",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Close button
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ),
                                            onPressed:
                                                () => Navigator.pop(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },
                          child: buildDetailCard("kjøreseddel Image", "File"),
                        ),
                      ],
                    ),
                  ],
                )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  // Reusable widget
  Widget buildDetailCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: CommonStyle.textStyleSmall(size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
