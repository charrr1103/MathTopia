import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A StatefulWidget that allows children to compare two numbers
/// by dragging them into left and right cards and identifying the larger number.
class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  late int number1; // First random number
  late int number2; // Second random number
  int? leftCardNumber; // Number dropped on the left card
  int? rightCardNumber; // Number dropped on the right card
  bool isNumber1Used = false; // Track if number1 has been used
  bool isNumber2Used = false; // Track if number2 has been used

  @override
  void initState() {
    super.initState();
    _generateNumbers();
  }

  /// Generates two distinct random numbers from 1 to 999
  void _generateNumbers() {
    setState(() {
      final random = Random();
      number1 = random.nextInt(999) + 1;
      number2 = random.nextInt(999) + 1;

      // Ensure the two numbers are not equal
      while (number1 == number2) {
        number2 = random.nextInt(999) + 1;
      }

      // Reset selections
      leftCardNumber = null;
      rightCardNumber = null;
      isNumber1Used = false;
      isNumber2Used = false;
    });
  }

  /// Checks whether the right number is greater than the left number
  /// and shows a feedback dialog.
  void _checkAnswer() {
    if (leftCardNumber != null && rightCardNumber != null) {
      bool isCorrect = (rightCardNumber! > leftCardNumber!);
      String message = isCorrect ? "Correct! 🎉" : "Try Again! ❌";
      String buttonText = isCorrect ? "Next" : "Try Again";
      IconData buttonIcon = isCorrect ? Icons.arrow_forward : Icons.refresh;

      // Show dialog with result
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text(
              message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (isCorrect) {
                    _generateNumbers(); // Generate new numbers if correct
                  } else {
                    _clearSelection(); // Reset only if incorrect
                  }
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
                      buttonText,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Icon(buttonIcon, color: Colors.white, size: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  /// Clears the selected numbers and resets the draggable availability.
  void _clearSelection() {
    setState(() {
      leftCardNumber = null;
      rightCardNumber = null;
      isNumber1Used = false;
      isNumber2Used = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Comparison of Numbers",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFCF2677),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
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
              child: SvgPicture.asset("assets/compare.svg", fit: BoxFit.cover),
            ),
            _buildTitle(),
            _buildDraggableNumbers(),
            _buildDropTargets(),
            _buildClearButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the instructional title at the top.
  Widget _buildTitle() {
    return Positioned(
      top: 140,
      left: 0,
      right: 0,
      child: Column(
        children: [
          _buildTitleText("Drag the numbers"),
          _buildTitleText("into the cards below"),
        ],
      ),
    );
  }

  /// Reusable styled title text
  Widget _buildTitleText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown.shade700),
    );
  }

  /// Builds the draggable number cards (pink and blue)
  Widget _buildDraggableNumbers() {
    return Positioned(
      top: 230,
      left: 80,
      right: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isNumber1Used && leftCardNumber != number1 && rightCardNumber != number1)
            _buildDraggable(number1, Colors.pink),
          if (!isNumber2Used && leftCardNumber != number2 && rightCardNumber != number2)
            _buildDraggable(number2, Colors.blue),
        ],
      ),
    );
  }

  /// Wraps a number in a draggable widget
  Widget _buildDraggable(int number, Color color) {
    return Draggable<int>(
      data: number,
      feedback: _buildNumberBox(number, color), // Dragged view
      childWhenDragging: _buildNumberBox(null, color), // Placeholder while dragging
      child: _buildNumberBox(number, color), // Default view
    );
  }

  /// Builds the drop zones (left and right cards)
  Widget _buildDropTargets() {
    return Positioned(
      bottom: 150,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDropTarget(false),
              const SizedBox(width: 150),
              _buildDropTarget(true),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLabel("Smaller"),
              const SizedBox(width: 170),
              _buildLabel("Bigger"),
            ],
          ),
          const SizedBox(height: 3),
          SvgPicture.asset("assets/chick.svg", width: 150),
        ],
      ),
    );
  }

  /// Styled number container used for both draggable and dragged view
  Widget _buildNumberBox(int? number, Color color) {
    return Container(
      width: 100,
      height: 130,
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

  /// Labels for the drop zones ("Smaller" and "Bigger")
  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  /// Builds a single drop target. isRight determines left/right side.
  Widget _buildDropTarget(bool isRight) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        setState(() {
          int droppedValue = details.data;
          if (isRight) {
            rightCardNumber = droppedValue;
          } else {
            leftCardNumber = droppedValue;
          }

          // Mark which number was used
          isNumber1Used = droppedValue == number1;
          isNumber2Used = droppedValue == number2;
        });
        _checkAnswer();
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 110,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.pink, width: 4),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            isRight ? (rightCardNumber?.toString() ?? "?") : (leftCardNumber?.toString() ?? "?"),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        );
      },
    );
  }

  /// Builds the "Clear" button to reset current selection
  Widget _buildClearButton() {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 130),
        child: ElevatedButton(
          onPressed: _clearSelection,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      ),
    );
  }
}
