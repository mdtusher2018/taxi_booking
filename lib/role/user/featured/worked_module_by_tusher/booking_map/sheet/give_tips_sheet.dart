import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';
import 'package:taxi_booking/role/user/featured/worked_module_by_tusher/booking_map/views/take_reward_view_view.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';

class GiveTipsSheet extends StatefulWidget {
  const GiveTipsSheet({super.key});

  @override
  State<GiveTipsSheet> createState() => _GiveTipsSheetState();
}

class _GiveTipsSheetState extends State<GiveTipsSheet> {
  final List<int> _presetTips = [5, 10, 15, 20];
  int? _selectedTip;
  final TextEditingController _customTipController = TextEditingController();

  void _selectTip(int amount) {
    setState(() {
      _selectedTip = amount;
      _customTipController.clear();
    });
  }

  void _selectCustomTip(String value) {
    setState(() {
      _selectedTip = int.tryParse(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
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
              const SizedBox(height: 20),

              // Heading
              const Center(
                child: Text(
                  "Wow 5 star!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Do you want to give an additional tip for Arlene?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // Preset tip buttons
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    _presetTips.map((amount) {
                      final bool isSelected = _selectedTip == amount;
                      return GestureDetector(
                        onTap: () => _selectTip(amount),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? Colors.yellow[700] : Colors.white,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Colors.yellow[700]!
                                      : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "\$$amount",
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),

              // Custom tip input
              TextField(
                controller: _customTipController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Custom Tip Amount",
                  prefixText: "\$",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: _selectCustomTip,
              ),
              const SizedBox(height: 20),

              // Pay Tip button
              CustomButton(
                onTap: () {
                  if (_selectedTip != null && _selectedTip! > 0) {
                    // Handle tip payment logic
                    Navigator.pop(context);
                    print("Tip amount: \$_selectedTip");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TakeRewardViewView();
                        },
                      ),
                    );
                  } else {
                    CustomToast.showToast(
                      message: "Please select a tip amount.",
                      isError: true,
                    );
                  }
                },
                title: "Pay Tip",
              ),
              const SizedBox(height: 12),

              // No Thanks button
              CustomButton(
                onTap: () {
                  Navigator.pop(context);
                },
                buttonColor: Color(0xffEAECF0),
                titleColor: AppColors.blackColor,
                title: "No Thanks!",
              ),
            ],
          ),
        );
      },
    );
  }
}
