/* import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  const MyBird({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Image.asset('assets/images/flapy.png'),
    );
  }
}
 */
import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  const MyBird({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 20 * 0.0174533, // 45 dereceyi radyana çeviriyoruz
      child: SizedBox(
        height: 100,
        width: 100,
        child: Image.asset('assets/images/flapy.png'),
      ),
    );
  }
  /* void playSound() async {
    String path = "assets/sounds/hegg.mp3"; 

    // Ses dosyasını çal
    await _audioPlayer.play(path, isLocal: true);

    
  } */
}

