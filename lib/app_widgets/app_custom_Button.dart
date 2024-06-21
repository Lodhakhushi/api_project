import 'package:flutter/material.dart';

class AppCustomtBtn extends StatefulWidget {

  String mTitle;
  Color TextColor;
  Color mBgcolor;
  Size? mSize;
  double mBorderRadius;
  void Function() onTap;


  AppCustomtBtn({
    required this.mTitle,
    required this.mBgcolor,
    required this.TextColor,
    this.mSize,
    this.mBorderRadius=10.0,
    required this.onTap});

  @override
  State<AppCustomtBtn> createState() => _AppCustomtBtnState();
}

class _AppCustomtBtnState extends State<AppCustomtBtn> {
  @override
  Widget build(BuildContext context) {
    return   ElevatedButton(
      onPressed: widget.onTap,
      child: Text(
        widget.mTitle,
        style:
        TextStyle(color: widget.TextColor, fontWeight: FontWeight.bold,fontSize: 20),
      ),

      style: ElevatedButton.styleFrom(minimumSize:widget.mSize ?? Size(250,40),
          backgroundColor: widget.mBgcolor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.mBorderRadius))),

    );
  }
}
