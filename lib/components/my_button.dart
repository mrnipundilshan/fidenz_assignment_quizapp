import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * 0.1,
      height: width * 0.1,
      child: ElevatedButton(
        onPressed: function,
        style: ElevatedButton.styleFrom(
          backgroundColor: title == "X"
              ? Colors.redAccent
              : title == "✓"
              ? Colors.green
              : isSelected
              ? Colors.black
              : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: SizedBox(
          child: Text(
            title,
            style: TextStyle(
              color: title == "✓"
                  ? Colors.white
                  : title == "X"
                  ? Colors.white
                  : isSelected
                  ? Colors.white
                  : Colors.black,
              fontSize: width * 0.1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
