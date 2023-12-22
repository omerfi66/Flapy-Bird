import 'dart:async';

import 'package:flapy_bird/barriers.dart';
import 'package:flapy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;
  double score = 0;
  double highScore = 0;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void resetGame() {
    setState(() {
      birdYaxis = 0.5;
      time = 0;
      height = 0;
      initialHeight = birdYaxis;
      gameHasStarted = false;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.5;
      score = 0;
    });
    startGame();
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
        barrierXone -= 0.05;
        barrierXtwo -= 0.05;
      });

      setState(() {
        if (barrierXone < -2) {
          barrierXone += 3.5;
          score++;
        } else {
          barrierXone -= 0.05;
        }
      });

      setState(() {
        if (barrierXtwo < -2) {
          barrierXtwo += 3.5;
          score++;
        } else {
          barrierXtwo -= 0.05;
        }
      });

      if (birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog(context);
      }

      if (birdYaxis > 1 ||
          (barrierXone < 0.2 && barrierXone > -0.2) &&
              (birdYaxis < -0.3 || birdYaxis > 0.3) ||
          (barrierXtwo < 0.1 && barrierXtwo > -0.1) &&
              (birdYaxis < -0.8 || birdYaxis > 0.8)) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: const Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: const MyBird(),
                  ),
                  Container(
                    alignment: const Alignment(0, -0.3),
                    child: gameHasStarted
                        ? const Text(' ')
                        : const Text(
                            'T A P  T O  P L A Y',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarriers(
                      size: 170.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarriers(
                      size: 170.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarriers(
                      size: 120.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: const Duration(milliseconds: 0),
                    child: const MyBarriers(
                      size: 220.0,
                    ),
                  ),
                ],
              )),
          Container(
            height: 15,
            color: Colors.green,
          ),
          Expanded(
              child: Container(
            color: Colors.brown,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'SCORE',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(score.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 35))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'BEST',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(highScore.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 35))
                    ],
                  ),
                ]),
          ))
        ]),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: const Text(
            'GAME OVER',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Score: $score',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            FloatingActionButton(
              backgroundColor: Colors.brown,
              elevation: 0,
              child: const Text(
                'PLAY AGAIN',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Oyunu sıfırla ve tekrar başlat
                setState(() {
                  if (score > highScore) {
                    highScore = score;
                  }
                  birdYaxis = 0.5;
                  time = 0;
                  height = 0;
                  initialHeight = birdYaxis;
                  gameHasStarted = false;
                  barrierXone = 1;
                  barrierXtwo = barrierXone + 1.5;
                  score = 0;
                });
                Navigator.of(context).pop(); // Dialog'u kapat
                startGame(); // Oyunu tekrar başlat
              },
            ),
          ],
        );
      },
    );
  }
}