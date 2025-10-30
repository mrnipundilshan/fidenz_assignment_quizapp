import 'dart:developer';

import 'package:fidenz_assignment_quizapp/components/my_button.dart';
import 'package:fidenz_assignment_quizapp/data/repositories/score_repository.dart';
import 'package:fidenz_assignment_quizapp/data/services/quection_api_service.dart';
import 'package:fidenz_assignment_quizapp/data/repositories/quection_repository.dart';
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
  late final QuectionRepository _quectionRepository;
  final ScoreRepository _scoreRepository = ScoreRepository();

  // Add this function in your _HomePageState
  void resetGame() {
    setState(() {
      quizcount = 0;
      score = 0;
      skipCount = 0;
      fails = 0;
      selectedIndex = null;
      selectedNumber = null;
      solution = null;

      loadQuections();
      loadHighScore();
      // Restart timers
      _timeTextController.restart();
      _timerBarController.reset();
      _timerBarController.start();
    });
  }

  // key pad String list
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
    {'title': '0', 'color': Color(0xFF6e377e)},
    {'title': '✓', 'color': Color(0xFF6e377e)},
  ];

  // choosen selection index in numpad
  int? selectedIndex;

  // selected number
  int? selectedNumber;

  // solution
  int? solution;

  // fails count
  int fails = 0;

  // timer controllers
  late final LinearTimerController _timerBarController;
  final CountdownController _timeTextController = CountdownController(
    autoStart: true,
  );

  // progress bar first start indicator
  bool _autoStarted = false;

  // game variable
  int quizcount = 0;
  int score = 0;
  int skipCount = 0;
  int highScore = 0;

  @override
  void initState() {
    super.initState();

    // load data at first load
    _quectionRepository = QuectionRepository(QuectionApiService());
    loadQuections();
    loadHighScore();
    _timerBarController = LinearTimerController(this);

    // Auto-start once, after first question loads
    question.then((_) {
      if (mounted && !_autoStarted) {
        _autoStarted = true;
        _timerBarController.start();
      }
    });
  }

  // load highscore
  void loadHighScore() async {
    final savedHighScore = await _scoreRepository.getHighScore();
    setState(() {
      highScore = savedHighScore;
    });
  }

  // updatehighscore
  void updatehighscore(int newScore) async {
    await _scoreRepository.saveHighScore(newScore);
  }

  // dispose
  @override
  void dispose() {
    _timerBarController.dispose();
    super.dispose();
  }

  // load quection
  void loadQuections() {
    question = _quectionRepository.getQections();
  }

  // format error messages (hide 'Exception: ' prefix)
  String _formatError(Object? error) {
    if (error == null) return 'Something went wrong. Please try again.';
    final String text = error.toString();
    const String prefix = 'Exception: ';
    if (text.startsWith(prefix)) {
      return text.substring(prefix.length);
    }
    return text;
  }

  // selected number function
  void selectedNumberFunction(int index, String numberValue) {
    setState(() {
      selectedIndex = index; // updates selected index
      selectedNumber = int.parse(numberValue); // store number as int
      //print(numberValue);
    });
  }

  // delete number logic
  void deleteNumberFunction() {
    setState(() {
      selectedIndex = null; // remove selected index
    });
  }

  // done  function
  void doneFunction() {
    if (selectedNumber != null) {
      if (selectedNumber == solution) {
        setState(() {
          score++;
          quizcount++;
          loadQuections();
        });
        // call congratulations message for passing score 10 by 10
        if (score % 10 == 0) {
          congratulationsMessage();
        }
        // call update high score if score>highscore
        if (score > highScore) {
          updatehighscore(score);
        }

        // Restart both text timer and linear bar
        _timeTextController.restart();
        _timerBarController.reset();
        _timerBarController.start();
      }
      if (selectedNumber != solution) {
        // Load new question
        setState(() {
          loadQuections();
          quizcount++;
          fails++;
        });

        // Restart both text timer and linear bar
        _timeTextController.restart();
        _timerBarController.reset();
        _timerBarController.start();
      }
    } else {
      log('No number selected');
    }
  }

  // message for passing score 10 by 10
  void congratulationsMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          "🎉 Congratulations!!!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF6e377e),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // app bar
      appBar: AppBar(
        backgroundColor: Color(0xFF6e377e),
        title: Text(
          "Quiz Game",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      backgroundColor: Color(0xFFb596b9),

      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // score area
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF6e377e),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                width: double.infinity,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // quection no
                        Text(
                          "Question No : $quizcount",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),

                        // skip count
                        Text(
                          "Skip Count   : $skipCount",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),

                        // score
                        Text(
                          "Score.           : $score",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),

                        SizedBox(height: 10),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "High Score  : $highScore",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),
                        Row(
                          children: List.generate(3, (index) {
                            return Icon(
                              Icons.favorite,
                              color: index < fails ? Colors.white : Colors.pink,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                child: fails > 2
                    // if loses 3 times -> game end
                    ? SizedBox(
                        height: width,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                "Score: $score",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.09,
                                  color: Color(0xFF6e377e),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6e377e),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  resetGame(); // reset everything
                                },
                                child: Text(
                                  "start again",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.05,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    // game screen
                    : Column(
                        children: [
                          // timer progress bar
                          const SizedBox(height: 15),
                          LinearTimer(
                            forward: false,
                            minHeight: 10,
                            duration: const Duration(seconds: 20),
                            controller: _timerBarController,
                          ),

                          // text count down
                          const SizedBox(height: 6),
                          Align(
                            alignment: AlignmentGeometry.centerLeft,
                            child: Countdown(
                              seconds: 20,
                              controller: _timeTextController,
                              build: (BuildContext context, double time) =>
                                  Text(
                                    '${time.toInt()} seconds remaining...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.04,
                                    ),
                                  ),
                              interval: Duration(seconds: 1),
                              onFinished: () {
                                // Load new question
                                setState(() {
                                  loadQuections();
                                  quizcount++;
                                  selectedIndex = null;
                                  selectedNumber = null;
                                  solution = null;

                                  fails++;
                                  skipCount++;
                                });

                                // Restart both text timer and linear bar
                                _timeTextController.restart();
                                _timerBarController.reset();
                                _timerBarController.start();
                              },
                            ),
                          ),

                          // image view
                          const SizedBox(height: 8),
                          Container(
                            width: width,
                            height: width * 0.45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                            ),

                            child: FutureBuilder<QuectionModel>(
                              future: question,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
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
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.wifi_off,
                                          size: 48,
                                          color: Colors.blueGrey,
                                        ),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          child: Text(
                                            _formatError(snapshot.error),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: width * 0.04,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF6e377e,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              loadQuections();
                                            });
                                          },
                                          child: const Text(
                                            'Retry',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  final question = snapshot.data;

                                  // store solution
                                  solution = question!.solution;
                                  //print(solution);
                                  // display the question image
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      question.question,
                                      fit: BoxFit.fill,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.broken_image_outlined,
                                                    size: 48,
                                                    color: Colors.blueGrey,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Failed to load image',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: width * 0.04,
                                                      color: Colors.blueGrey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: Text('No data found'),
                                  );
                                }
                              },
                            ),
                          ),

                          // num pad
                          const SizedBox(height: 15),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 50,
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
                                  switch (item['title']) {
                                    case 'X':
                                      setState(() {
                                        // numpad clear function
                                        deleteNumberFunction();
                                      });

                                      break;

                                    case '✓':
                                      // done function
                                      doneFunction();
                                      setState(() {
                                        selectedIndex = null;
                                      });
                                      break;

                                    default:
                                      // all numbers (0–9)
                                      selectedNumberFunction(
                                        index,
                                        item['title'],
                                      );
                                      break;
                                  }
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
