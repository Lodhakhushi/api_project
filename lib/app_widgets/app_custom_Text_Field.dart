import 'package:flutter/material.dart';

class AppCustomTextField extends StatefulWidget {
  final TextEditingController mController;
  final IconData? mPreffixIcon;
  final double mBorderRadius;
  final String mText;
  final IconData? mSuffixIcon;
  final Function()? onSuffixIconPressed;
  final  keyboardType;

  const AppCustomTextField({
    required this.mController,
    this.mPreffixIcon,
    this.mBorderRadius = 10.0,
    this.mText='null',
    this.mSuffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType
  });

  @override
  _AppCustomTextFieldState createState() => _AppCustomTextFieldState();
}

class _AppCustomTextFieldState extends State<AppCustomTextField> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.mController,
        obscureText: _obscureText,
        cursorColor: Colors.black,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.mPreffixIcon),
          suffixIcon: widget.mSuffixIcon != null
              ? InkWell(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
              if (widget.onSuffixIconPressed != null) {
                widget.onSuffixIconPressed!();
              }
            },
            child: Icon(widget.mSuffixIcon,),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.mBorderRadius),
            gapPadding: double.infinity,
            borderSide: BorderSide(
              color: Colors.grey.shade900,
              style: BorderStyle.solid,
            ),
          ),
          iconColor: Colors.black,
          hintText: widget.mText,
        ),
      ),
    );
  }
}
