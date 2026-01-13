// file: password_strength_widget.dart
import 'package:flutter/material.dart';

class PasswordStrengthWidget extends StatelessWidget {
  final int strength;
  final String label;

  const PasswordStrengthWidget({
    super.key,
    required this.strength,
    required this.label,
  });

  Color getColor() {
    if (strength <= 2) return Colors.red;
    if (strength <= 4) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                height: 5,
                decoration: BoxDecoration(
                  color: index < strength ? getColor() : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
