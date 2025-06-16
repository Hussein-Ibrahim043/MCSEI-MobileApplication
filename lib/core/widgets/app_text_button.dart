import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Size? size;
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize:
            size ?? Size(ScreenUtil().screenWidth, 50.h), // Button size,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor:
            Color.fromARGB(255, 26, 85, 152), // Text and icon color
        shadowColor: Colors.black, // Shadow color
        elevation: 5, // Elevation
        padding: EdgeInsets.symmetric(
            horizontal: 32, vertical: 16), // Button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        textStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ), // Text style
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}