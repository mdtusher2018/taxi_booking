import 'package:flutter/material.dart';

class CustomCheckBoxWithTitle extends StatelessWidget {
  final String title;
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final TextStyle? textStyle;
  final Color activeColor;
  final double spacing;

  const CustomCheckBoxWithTitle({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onChanged,
    this.textStyle,
    this.activeColor = Colors.blue,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isChecked), // toggle on tap anywhere
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
            activeColor: activeColor,
          ),
          SizedBox(width: spacing),
          Flexible(
            child: Text(
              title,
              style: textStyle ??
                  const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
