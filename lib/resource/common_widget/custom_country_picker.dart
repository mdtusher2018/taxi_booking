// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CustomCountryPicker extends StatefulWidget {
  final String titleText;
  final String hintText;
  final TextEditingController? controller;
  final bool? isLabelHidden;
  final String defaultIsoCode;

  CustomCountryPicker({
    Key? key,
    required this.titleText,
    required this.hintText,
    this.controller,
    this.isLabelHidden = false,
    this.defaultIsoCode = 'US',
  }) : super(key: key);

  @override
  State<CustomCountryPicker> createState() => _CustomCountryPickerState();
}

class _CustomCountryPickerState extends State<CustomCountryPicker> {
  final FocusNode _focusNode = FocusNode();
  // ignore: unused_field
  PhoneNumber? _phoneNumber;
  late PhoneNumber _initialPhoneNumber;

  @override
  void initState() {
    super.initState();
    _initialPhoneNumber = PhoneNumber(isoCode: widget.defaultIsoCode);
    _phoneNumber = _initialPhoneNumber;
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(CustomCountryPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the defaultIsoCode has changed
    if (oldWidget.defaultIsoCode != widget.defaultIsoCode) {
      setState(() {
        _initialPhoneNumber = PhoneNumber(isoCode: widget.defaultIsoCode);
        _phoneNumber = _initialPhoneNumber;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onInputChanged(PhoneNumber number) {
    setState(() {
      _phoneNumber = number;
    });

    if (widget.controller != null) {
      widget.controller!.text = number.phoneNumber ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isLabelHidden!)
          Text(
            widget.titleText,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        if (!widget.isLabelHidden!) const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: _focusNode.hasFocus ? Colors.red : Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InternationalPhoneNumberInput(
                key: ValueKey(widget.defaultIsoCode),
                focusNode: _focusNode,
                inputBorder: InputBorder.none,
                onInputChanged: _onInputChanged,
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  useEmoji: true,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(
                  color: _focusNode.hasFocus ? Colors.red : Colors.black,
                ),
                initialValue: _initialPhoneNumber, // ✅ Use the state variable
                formatInput: true,
                inputDecoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.urbanist(
                    color: Color(0xff595959),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
