import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final double width;
  final String title;
  final bool isSelected;
  final VoidCallback? function;
  const MyButton({
    super.key,
    required this.width,
    required this.title,
    required this.isSelected,
    this.function,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width * 0.2,
      height: widget.width * 0.2,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF6e377e),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // circular corners
          ),
        ),
        child: Text(
          "1",
          style: TextStyle(
            color: Colors.black,
            fontSize: widget.width * 0.1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
