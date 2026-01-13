import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi_booking/resource/app_colors/app_colors.dart';


class CustomTextField extends StatefulWidget {
  final String hint;
  final double? height;
  final double? verticalPadding;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color focusColor;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final int? maxLine;
  final TextAlign textAlign;
  final bool readOnly;
  final TextStyle? style;
  final bool obscureText;
  final String obscuringCharacter;
  final Function(String?)? onSaved;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final bool? filled;
  final Color? hintColor;
  final Color fillColor;
  final double focusBorderRadius;
  final double focusBorderWidth;
  final String? errorText;
  final String? Function(String?)? validator;
  final bool isBorder;
  final bool? isFocus;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.hint,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.focusColor = AppColors.mainColor,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.maxLine = 1,
    this.readOnly = false,
    thiscureText = false,
    this.textAlign = TextAlign.start,
    thiscuringCharacter = '•',
    this.style,
    this.onSaved,
    this.borderRadius = 8,
    this.focusBorderRadius = 8,
    this.borderColor = const Color(0xffEBEBEB),
    this.borderWidth = 1.0,
    this.filled = true,
    this.fillColor = const Color(0xffFFFFFF),
    this.focusBorderWidth = 1.5,
    this.errorText,
    this.validator,
    this.hintColor,
    this.height,
    this.verticalPadding,
    this.isBorder = true,
    this.isFocus = true,
    this.obscureText = false,
    this.focusNode,
    this.obscuringCharacter = "*",
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscureText;

  @override
  void initState() {
    super.initState();
    _isObscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscureText = !_isObscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height:
          (widget.errorText == null
              ? MediaQuery.of(context).size.height / 16
              : MediaQuery.of(context).size.height / 10),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          filled: widget.filled,
          fillColor: widget.fillColor,
          focusedBorder:
              widget.isFocus == true
                  ? OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.focusColor,
                      width: widget.focusBorderWidth,
                    ),
                    borderRadius: BorderRadius.circular(
                      widget.focusBorderRadius,
                    ),
                  )
                  : null,
          border: OutlineInputBorder(
            borderSide:
                widget.isBorder == false
                    ? BorderSide.none
                    : BorderSide(
                      width: widget.borderWidth,
                      color: widget.borderColor,
                    ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          hintText: widget.hint,
          hintStyle: GoogleFonts.poppins(
            color: widget.hintColor ?? Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    icon: Icon(
                      _isObscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: _togglePasswordVisibility,
                  )
                  : widget.suffixIcon,
          errorText: widget.errorText,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: widget.verticalPadding ?? 0,
          ),
        ),
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLine,
        textAlign: widget.textAlign,
        readOnly: widget.readOnly,
        style: widget.style,
        focusNode: widget.focusNode,
        obscureText: _isObscureText,
        obscuringCharacter: widget.obscuringCharacter,
        onSaved: widget.onSaved,
        validator: widget.validator,
      ),
    );
  }
}
