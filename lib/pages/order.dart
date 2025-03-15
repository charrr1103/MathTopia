import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with SingleTickerProviderStateMixin {
  late List<int> numbers;
  late List<int?> userOrder;
  late bool isAscending;
  bool isCompleted = false;
  Set<int> placedNumbers = {}; // To track used numbers

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _generateNumbers();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateNumbers() {
    setState(() {
      final random = Random();
      numbers = List.generate(4, (_) => random.nextInt(99) + 1);
      numbers = numbers.toSet().toList(); // Remove duplicates
      while (numbers.length < 4) {
        numbers.add(random.nextInt(99) + 1);
      }
      numbers.shuffle();
      isAscending = random.nextBool();
      userOrder = List.filled(4, null);
      isCompleted = false;
      placedNumbers.clear(); // Reset placed numbers
    });
  }

  void _checkAnswer() {
    if (!userOrder.contains(null)) {
      List<int> correctOrder = List.from(numbers)..sort();
      if (!isAscending) correctOrder = correctOrder.reversed.toList();

      bool isCorrect = const ListEquality().equals(userOrder, correctOrder);
      if (isCorrect) {
        setState(() {
          isCompleted = true;
        });
        _showResultDialog("Correct! 🎉");
      } else {
        _showResultDialog("Try Again! ❌");
      }
    }
  }

  void _showResultDialog(String message) {
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
            width: double.infinity, // Full-width button
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _generateNumbers();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Next",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(width: 10), // Space between text and icon
                  Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearOrder() {
    setState(() {
      userOrder = List.filled(4, null);
      placedNumbers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order the Numbers",
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
                    isAscending ? "Arrange in Ascending Order 🔼" : "Arrange in Descending Order 🔽",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade700,
                    ),
                  ),
                ],
              ),
            ),
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
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) => _buildDropTarget(index)),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4, // Adjusted to move the otter slightly up
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

  Widget _buildDraggableNumber(int number) {
    return Draggable<int>(
      data: number,
      feedback: _buildNumberBox(number, Colors.blue),
      childWhenDragging: _buildNumberBox(null, Colors.blue),
      child: _buildNumberBox(number, Colors.blue),
    );
  }

  Widget _buildDropTarget(int index) {
    double baseWidth = 85; // Fixed width for all boxes
    double baseHeight = 100; // Base height for the smallest box
    double scaleFactor = 20; // Increase/decrease factor for height

    // Calculate height based on ascending or descending order
    double height = isAscending
        ? baseHeight + (index * scaleFactor)  // Increase height in ascending order
        : baseHeight + ((3 - index) * scaleFactor);  // Decrease height in descending order

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
        _checkAnswer();
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: baseWidth,  // Keep width fixed
          height: height,   // Adjust height based on order
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.pink, width: 4),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,  // Align the content in the center of the card
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

  Widget _buildNumberBox(int? number, Color color) {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,  // Center the number in the box
      child: number != null
          ? Text(
        number.toString(),
        style: const TextStyle(fontSize: 32, color: Colors.white),
      )
          : null,
    );
  }
}