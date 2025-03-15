import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  late int number1;
  late int number2;
  int? leftCardNumber;
  int? rightCardNumber;
  bool isNumber1Used = false;
  bool isNumber2Used = false;

  @override
  void initState() {
    super.initState();
    _generateNumbers();
  }

  void _generateNumbers() {
    setState(() {
      final random = Random();
      number1 = random.nextInt(99) + 1;
      number2 = random.nextInt(99) + 1;

      while (number1 == number2) {
        number2 = random.nextInt(99) + 1;
      }

      leftCardNumber = null;
      rightCardNumber = null;
      isNumber1Used = false;
      isNumber2Used = false;
    });
  }

  void _checkAnswer() {
    if (leftCardNumber != null && rightCardNumber != null) {
      bool isCorrect = (rightCardNumber! > leftCardNumber!);
      String message = isCorrect ? "Correct! 🎉" : "Try Again! ❌";

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
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

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
            colors: [Color(0xFF65E3FF), Colors.white],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                "assets/compare.svg",
                fit: BoxFit.cover,
              ),
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

  Widget _buildTitleText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.brown.shade700,
      ),
    );
  }

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

  Widget _buildDraggable(int number, Color color) {
    return Draggable<int>(
      data: number,
      feedback: _buildNumberBox(number, color),
      childWhenDragging: _buildNumberBox(null, color),
      child: _buildNumberBox(number, color),
    );
  }

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
