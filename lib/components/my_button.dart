import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final double width;
  final String title;
  final bool isSelected;
  final VoidCallback? function;
  final Color color;
  const MyButton({
    super.key,
    required this.width,
    required this.title,
    required this.isSelected,
    this.function,
    required this.color,
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
        onPressed: widget.function,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.title == "X"
              ? Colors.redAccent
              : widget.title == "✓"
              ? Colors.green
              : widget.isSelected
              ? Colors.black
              : widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: widget.title == "✓"
                ? Colors.white
                : widget.title == "X"
                ? Colors.white
                : widget.isSelected
                ? Colors.white
                : Colors.black,
            fontSize: widget.width * 0.1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
