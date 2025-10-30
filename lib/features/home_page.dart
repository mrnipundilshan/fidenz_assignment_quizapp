import 'package:fidenz_assignment_quizapp/components/my_button.dart';
import 'package:fidenz_assignment_quizapp/data/services/quection_api_service.dart';
import 'package:fidenz_assignment_quizapp/models/quection_model.dart';
import 'package:flutter/material.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Future<QuectionModel> question;

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

  // choice in num pad
  int? selectedIndex;

  // timer controller
  late final LinearTimerController _timerBarController;
  final CountdownController _timeTextController = new CountdownController(
    autoStart: true,
  );
  bool _autoStarted = false;

  @override
  void initState() {
    super.initState();
    loadQuections();
    _timerBarController = LinearTimerController(this);
    // Auto-start once, after first question loads (ensures a build occurred)
    question.then((_) {
      if (mounted && !_autoStarted) {
        _autoStarted = true;
        _timerBarController.start();
      }
    });
  }

  void loadQuections() {
    question = QuectionApiService().getQections();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFb596b9),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.025),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // time
              LinearTimer(
                forward: false,
                minHeight: 10,
                duration: const Duration(seconds: 20),
                controller: _timerBarController,
              ),

              // text count down
              const SizedBox(height: 8),
              Countdown(
                seconds: 20,
                controller: _timeTextController,
                build: (BuildContext context, double time) => Text(
                  '${time.toInt()} seconds remaining...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                  ),
                ),
                interval: Duration(seconds: 1),
                onFinished: () {
                  // Restart both text timer and linear bar
                  _timeTextController.restart();
                  _timerBarController.reset();
                  _timerBarController.start();

                  // Load new question
                  setState(() {
                    loadQuections();
                  });
                },
              ),

              // image view
              Container(
                width: width * 0.85,
                height: width * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey, // shadow color
                      spreadRadius: 5, // how much the shadow spreads
                      blurRadius: 8, // softening the shadow
                      offset: const Offset(0, 0), // position: x=0, y=3
                    ),
                  ],
                ),

                child: FutureBuilder<QuectionModel>(
                  future: question,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          width: width * 0.2,
                          height: width * 0.2,
                          child: const CircularProgressIndicator(
                            color: Color(0xFFb596b9),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      final question = snapshot.data;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),

                        child: Image(
                          image: NetworkImage(question!.question),
                          fit: BoxFit.fill,
                        ),
                      );
                      // display the question image
                    } else {
                      return const Center(child: Text('No data found'));
                    }
                  },
                ),
              ),

              // num pad
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 45,
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
                    function: () async {
                      setState(() {
                        selectedIndex = index; // updates selected index
                      });
                    },
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _timerBarController.start();
                    },
                    child: const Text('Start'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      _timerBarController.reset();
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timerBarController.dispose();
    super.dispose();
  }
}
