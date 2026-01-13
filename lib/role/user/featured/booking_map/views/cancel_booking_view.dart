import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_checkbox_with_title.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import '../../../../../resource/utilitis/common_style.dart';

class CancelBookingView extends StatefulWidget {
  const CancelBookingView({super.key});

  @override
  State<CancelBookingView> createState() => _CancelBookingViewState();
}

class _CancelBookingViewState extends State<CancelBookingView> {
  final List<String> _reasons = [
    'Waiting for long time',
    'Wrong address shown',
    'The price is not reasonable',
    'Ride isn’t here',
    'Others',
  ];

  String? _selectedReason; // Only one selected at a time
  final TextEditingController _otherReasonController = TextEditingController();

  void _onReasonChanged(String reason) {
    setState(() {
      _selectedReason = reason;
    });
    debugPrint("Selected reason: $_selectedReason");
  }

  @override
  Widget build(BuildContext context) {
    final bool isOthersSelected = _selectedReason == 'Others';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Cancel Trip'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: 'Please select the reason for cancellation:',
              style: CommonStyle.textStyleMedium(size: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  ..._reasons.map((reason) {
                    return CustomCheckBoxWithTitle(
                      title: reason,
                      isChecked: _selectedReason == reason,
                      onChanged: (value) {
                        if (value) {
                          _onReasonChanged(reason);
                        } else {
                          _onReasonChanged('');
                        }
                      },
                    );
                  }),
                  if (isOthersSelected) ...[
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _otherReasonController,
                      maxLine: 3,
                      verticalPadding: 16,
                      hint: 'Please specify your reason',
                      height: MediaQuery.sizeOf(context).height / 8,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              title: 'Submit Reason',
              onTap: () {
                String? reasonToSubmit = _selectedReason;

                if (isOthersSelected &&
                    _otherReasonController.text.trim().isNotEmpty) {
                  reasonToSubmit = _otherReasonController.text.trim();
                }

                if (reasonToSubmit == null || reasonToSubmit.isEmpty) {
                  debugPrint("No reason selected");
                  CustomToast.showToast(
                    message: "Please select a reason",
                    isError: true,
                  );
                  return;
                }

                debugPrint("Reason submitted: $reasonToSubmit");
                CustomToast.showToast(
                  message:
                      "Reason submitted successfully, please wait for admin approval",
                  isError: false,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
