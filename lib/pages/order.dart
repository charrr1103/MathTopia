import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';

/// OrderPage is a StatefulWidget that allows users to drag and drop numbers
/// into their correct order (ascending or descending).
class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with SingleTickerProviderStateMixin {
  late List<int> numbers; // List of randomly generated numbers to be ordered
  late List<int?> userOrder; // User's attempted order of the numbers
  late bool isAscending; // Flag to indicate if the order should be ascending or descending
  bool isCompleted = false; // Flag to track if the user has completed the task
  Set<int> placedNumbers = {}; // Set of numbers that have been placed in the correct positions

  late AnimationController _controller; // Controller for animating the otter's movement

  @override
  void initState() {
    super.initState();
    _generateNumbers(); // Generate initial set of numbers when the page loads
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true); // Repeat animation of otter
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the animation controller when the page is disposed
    super.dispose();
  }

  /// Generates a list of 4 unique random numbers and sets up the ordering (ascending or descending).
  void _generateNumbers() {
    setState(() {
      final random = Random();
      numbers = List.generate(4, (_) => random.nextInt(999) + 1); // Generate numbers from 1 to 999
      numbers = numbers.toSet().toList(); // Ensure unique numbers
      while (numbers.length < 4) {
        numbers.add(random.nextInt(999) + 1); // Add more numbers until there are 4 unique numbers
      }
      numbers.shuffle(); // Shuffle the numbers randomly
      isAscending = random.nextBool(); // Randomly decide if the order is ascending or descending
      userOrder = List.filled(4, null); // Initialize user's order as null
      isCompleted = false; // Reset completion flag
      placedNumbers.clear(); // Clear any previously placed numbers
    });
  }

  /// Checks if the user’s order matches the correct order.
  void _checkAnswer() {
    if (!userOrder.contains(null)) { // Only check when all numbers are placed
      List<int> correctOrder = List.from(numbers)..sort(); // Sort numbers to get the ascending order
      if (!isAscending) correctOrder = correctOrder.reversed.toList(); // Reverse for descending order

      bool isCorrect = const ListEquality().equals(userOrder, correctOrder); // Compare user's order with the correct order
      setState(() {
        isCompleted = isCorrect; // Set completion flag based on correctness
      });
      _showResultDialog(isCorrect ? "Correct! 🎉" : "Try Again! ❌", isCorrect); // Show result dialog
    }
  }

  /// Displays a dialog with the result message and provides options to proceed.
  void _showResultDialog(String message, bool isCorrect) {
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
                  _generateNumbers(); // Generate new numbers if the answer is correct
                } else {
                  _clearOrder(); // Reset the order if the answer is incorrect
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
                children: [
                  Text(
                    isCorrect ? "Next" : "Try Again",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
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

  /// Clears the user's order and resets the placed numbers.
  void _clearOrder() {
    setState(() {
      userOrder = List.filled(4, null); // Reset the user's order to null
      placedNumbers.clear(); // Clear placed numbers
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order the Numbers",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
            colors: [
              Color(0xFF65E3FF),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                "assets/clouds.svg",
                fit: BoxFit.cover,
              ),
            ),
            // Display the instruction texts
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Drag the numbers",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade700,
                    ),
                  ),
                  Text(
                    "into the cards below.",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade700,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    isAscending ? "Arrange from smallest to largest" : "Arrange from largest to smallest", // Instruction based on order
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade700,
                    ),
                  ),
                ],
              ),
            ),
            // Display draggable numbers
            Positioned(
              top: 120,
              left: 50,
              right: 50,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: numbers
                    .where((num) => !placedNumbers.contains(num))
                    .map((num) => _buildDraggableNumber(num))
                    .toList(),
              ),
            ),
            // Display drop targets for numbers
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) => _buildDropTarget(index)),
              ),
            ),
            // Animated otter
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: sin(_controller.value * pi * 2) * 0.2,
                      child: child,
                    );
                  },
                  child: SvgPicture.asset(
                    "assets/otter.svg",
                    width: 160,
                  ),
                ),
              ),
            ),
            // Clear button at the bottom
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: _clearOrder,
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
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a draggable number widget.
  Widget _buildDraggableNumber(int number) {
    return Draggable<int>(
      data: number,
      feedback: _buildNumberBox(number, Colors.blue),
      childWhenDragging: _buildNumberBox(null, Colors.blue),
      child: _buildNumberBox(number, Colors.blue),
    );
  }

  /// Builds a drop target container for the numbers.
  Widget _buildDropTarget(int index) {
    double baseWidth = 85;
    double baseHeight = 100;
    double scaleFactor = 20;

    double height = isAscending
        ? baseHeight + (index * scaleFactor)
        : baseHeight + ((3 - index) * scaleFactor);

    return DragTarget<int>(
      onWillAcceptWithDetails: (data) => !placedNumbers.contains(data),
      onAcceptWithDetails: (details) {
        int data = details.data;
        setState(() {
          if (userOrder[index] != null) {
            placedNumbers.remove(userOrder[index]!);
          }
          userOrder[index] = data;
          placedNumbers.add(data);
        });
        _checkAnswer(); // Check answer after placing number
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: baseWidth,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.pink, width: 4),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: userOrder[index] != null
              ? Text(
            userOrder[index].toString(),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          )
              : null,
        );
      },
    );
  }

  /// Builds a number box container.
  Widget _buildNumberBox(int? number, Color color) {
    return Container(
      width: 80,
      height: 100,
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
