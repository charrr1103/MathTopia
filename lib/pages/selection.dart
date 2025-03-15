import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_topia/pages/compare.dart';
import 'package:math_topia/pages/order.dart';
import 'package:math_topia/pages/compose.dart';
import 'package:audioplayers/audioplayers.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playMusic();
  }

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource("music.mp3"));
    } catch (e) {
      print("Error playing music: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select an Option",
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFCF2677),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Ensures back button is also white
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFBCFF8D),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectionButton(
                iconPath: "assets/icon1.svg",
                label: "Compare",
                iconSize: screenWidth * 0.35,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ComparePage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              SelectionButton(
                iconPath: "assets/icon2.svg",
                label: "Order",
                iconSize: screenWidth * 0.35,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              SelectionButton(
                iconPath: "assets/icon3.svg",
                label: "Compose",
                iconSize: screenWidth * 0.35,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ComposePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectionButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final double iconSize;
  final VoidCallback onTap;

  const SelectionButton({
    super.key,
    required this.iconPath,
    required this.label,
    required this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFCF2677),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
