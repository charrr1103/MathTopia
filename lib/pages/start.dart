import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_topia/pages/selection.dart';
import 'package:math_topia/audio_manager.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
    AudioManager().playMusic(); // Start playing background music
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF65E3FF),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset("assets/bg.svg", fit: BoxFit.cover),
            ),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  "assets/Logo.svg",
                  width: 350,
                ),
              ),
            ),
            Positioned(
              top: 50, 
              right: 20,
              child: IconButton(
                icon: Icon(
                  AudioManager().isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    AudioManager().toggleMute();
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectionPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.white, width: 3),
                    ),
                    elevation: 10,
                  ),
                  //start button
                  child: const Text(
                    "Start",
                    style: TextStyle(
                      fontFamily: 'Super Bubble',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
