import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  List<int> numbers = List.generate(10, (index) => index); // 0-9
  List<int?> selectedNumbers = [null, null];
  int targetNumber = 10;

  @override
  void initState() {
    super.initState();
    _generateNewTarget();
  }

  void _generateNewTarget() {
    Random random = Random();
    int num1, num2;

    do {
      num1 = random.nextInt(10); // Random number between 0-9
      num2 = random.nextInt(10); // Another random number between 0-9
    } while (num1 + num2 == 0); // Ensure target is not 0

    targetNumber = num1 + num2; // Ensure target is a sum of two numbers
    setState(() {});
  }

  void _checkAnswer() {
    setState(() {
      selectedNumbers = [null, null];
    });
  }

  void _showResultDialog() {
    int sum = (selectedNumbers[0] ?? 0) + (selectedNumbers[1] ?? 0);
    bool isCorrect = sum == targetNumber;
    String message = isCorrect ? "Correct! 🎉" : "Wrong! ❌";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        content: Center(
          heightFactor: 1,
          child: Text(
            "You formed: $sum",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (isCorrect) {
                  _generateNewTarget(); // Only generate new target if correct
                }
                _checkAnswer(); // Always clear selection
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCorrect ? Colors.pink : Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isCorrect ? "Next" : "Try Again",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    isCorrect ? Icons.arrow_forward : Icons.refresh,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedNumbers[0] != null && selectedNumbers[1] != null) {
      Future.delayed(const Duration(milliseconds: 300), _showResultDialog);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Compose Numbers",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFCF2677),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF65E3FF), Colors.white],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset("assets/compose.svg", fit: BoxFit.cover),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        "Add two numbers to make:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "$targetNumber",
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Drag the numbers below:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding( // Add padding around the Wrap widget
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 5,
                          runSpacing: 10,
                          children:
                          numbers.map((num) => _buildDraggableNumber(num)).toList(),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDropTarget(0),
                          const SizedBox(width: 130),
                          _buildDropTarget(1),
                        ],
                      ),
                      const SizedBox(height: 120),
                      ElevatedButton(
                        onPressed: _checkAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(color: Colors.white, width: 3),
                          ),
                        ),
                        child: const Text(
                          "Clear",
                          style: TextStyle(
                            fontFamily: 'Super Bubble',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableNumber(int number) {
    return Draggable<int>(
      data: number,
      feedback: _buildNumberBox(number, Colors.blue.withOpacity(0.8)),
      childWhenDragging: _buildNumberBox(null, Colors.blue.withOpacity(0.3)),
      child: _buildNumberBox(number, Colors.blue),
    );
  }

  Widget _buildDropTarget(int index) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (data) => selectedNumbers[index] == null,
      onAcceptWithDetails: (details) {
        setState(() {
          selectedNumbers[index] = details.data;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 90,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink, width: 4),
              ),
            ),
            if (selectedNumbers[index] != null)
              Text(
                selectedNumbers[index].toString(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildNumberBox(int? number, Color color) {
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: number != null
          ? Text(
        number.toString(),
        style: const TextStyle(fontSize: 32, color: Colors.white),
      )
          : null,
    );
  }
}
