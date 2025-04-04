import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ComposePage widget is the main screen for the compose number game.
class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

// State class for managing the ComposePage logic and UI.
class _ComposePageState extends State<ComposePage> {
  // List of numbers (0-9) for the user to choose from.
  List<int> numbers = List.generate(10, (index) => index); 

  // List of two selected numbers for the target.
  List<int?> selectedNumbers = [null, null];
  
  // The target number the user needs to form by selecting two numbers.
  int targetNumber = 10;

  @override
  void initState() {
    super.initState();
    _generateNewTarget(); // Generate the initial target number when the screen loads.
  }

  // Function to generate a new random target number by summing two random numbers.
  void _generateNewTarget() {
    Random random = Random();
    int num1, num2;

    do {
      num1 = random.nextInt(10); // Random number between 0-9
      num2 = random.nextInt(10); // Another random number between 0-9
    } while (num1 + num2 == 0); // Ensure target is not 0

    targetNumber = num1 + num2; // Ensure target is the sum of two numbers
    setState(() {}); // Rebuild the widget to show the new target
  }

  // Function to clear the selected numbers.
  void _checkAnswer() {
    setState(() {
      selectedNumbers = [null, null]; // Reset the selected numbers.
    });
  }

  // Function to display the result dialog with feedback on the answer.
  void _showResultDialog() {
    int sum = (selectedNumbers[0] ?? 0) + (selectedNumbers[1] ?? 0);
    bool isCorrect = sum == targetNumber; // Check if the sum is correct.
    String message = isCorrect ? "Correct! 🎉" : "Wrong! ❌";

    // Show the dialog with the result
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
                Navigator.pop(context); // Close the dialog
                if (isCorrect) {
                  _generateNewTarget(); // Generate a new target if the answer is correct
                }
                _checkAnswer(); // Always clear the selected numbers
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
    // Display result dialog if both numbers are selected
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
                      // Display the target number
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
                            "$targetNumber", // Show the current target number
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
                      Padding( 
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 5,
                          runSpacing: 10,
                          children: numbers
                              .map((num) => _buildDraggableNumber(num))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Display the drop targets where the user can drag numbers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDropTarget(0),
                          const SizedBox(width: 130),
                          _buildDropTarget(1),
                        ],
                      ),
                      const SizedBox(height: 120),
                      // Clear button to reset the selected numbers
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

  // Build a draggable number widget.
  Widget _buildDraggableNumber(int number) {
    return Draggable<int>(
      data: number,
      feedback: _buildNumberBox(number, Colors.blue.withOpacity(0.8)),
      childWhenDragging: _buildNumberBox(null, Colors.blue.withOpacity(0.3)),
      child: _buildNumberBox(number, Colors.blue),
    );
  }

  // Build a drop target where a user can drop a number.
  Widget _buildDropTarget(int index) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (data) => selectedNumbers[index] == null,
      onAcceptWithDetails: (details) {
        setState(() {
          selectedNumbers[index] = details.data; // Place the number into the drop target
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
            // Display the selected number inside the target if it is selected.
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

  // Build a box for displaying a number.
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
