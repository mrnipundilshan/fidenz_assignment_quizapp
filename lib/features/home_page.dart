import 'package:fidenz_assignment_quizapp/components/my_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // key pad list
  final List<Map<String, dynamic>> buttons = [
    {'title': '1', 'color': Color(0xFF6e377e)},
    {'title': '2', 'color': Color(0xFF6e377e)},
    {'title': '3', 'color': Color(0xFF6e377e)},
    {'title': '4', 'color': Color(0xFF6e377e)},
    {'title': '5', 'color': Color(0xFF6e377e)},
    {'title': '6', 'color': Color(0xFF6e377e)},
    {'title': '7', 'color': Color(0xFF6e377e)},
    {'title': '8', 'color': Color(0xFF6e377e)},
    {'title': '9', 'color': Color(0xFF6e377e)},
    {'title': 'X', 'color': Colors.redAccent},
    {'title': '9', 'color': Color(0xFF6e377e)},
    {'title': '✓', 'color': Color(0xFF6e377e)},
  ];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFb596b9),
      body: Center(
        child: GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: buttons.length,
          itemBuilder: (context, index) {
            final item = buttons[index];
            final bool isSelected = selectedIndex == index;

            return MyButton(
              width: width,
              title: item['title'],
              isSelected: isSelected,
              color: item['color'],
              function: () {
                setState(() {
                  selectedIndex = index; // updates selected index
                  print(selectedIndex);
                });
              },
            );
          },
        ),
      ),
    );
  }
}
