import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  List<int> numbers = List.generate(9, (index) => index + 1);
  List<int?> selectedNumbers = [null, null];

  void _updateCombination() {
    setState(() {});
  }

  void _clearSelection() {
    setState(() {
      selectedNumbers = [null, null];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Compose Numbers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFCF2677),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF65E3FF), // Light Blue
              Colors.white,       // White
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: SvgPicture.asset(
                "assets/compose.svg",
                fit: BoxFit.cover,
              ),
            ),

            // 🟢 Black Transparent Backdrop (only when the result box appears)
            if (selectedNumbers[0] != null && selectedNumbers[1] != null)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust transparency
                ),
              ),

            // Main UI Layout (Numbers, Drop Targets, Button)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: numbers.map((num) => _buildDraggableNumber(num)).toList(),
                ),

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDropTarget(0),
                    const SizedBox(width: 130), // Adds space between the two drop targets
                    _buildDropTarget(1),
                  ],
                ),

                const SizedBox(height: 50),

                // Pushes the "Clear" button to the bottom
                const Spacer(),

                ElevatedButton(
                  onPressed: _clearSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Button color
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                      side: const BorderSide(color: Colors.white, width: 3), // White border
                    ),
                  ),
                  child: const Text(
                    "Clear",
                    style: TextStyle(
                      fontFamily: 'Super Bubble',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Ensures text is readable on orange
                    ),
                  ),
                ),

                const SizedBox(height: 50), // Extra spacing from bottom
              ],
            ),

            // Floating result card (Now placed inside Stack)
            if (selectedNumbers[0] != null && selectedNumbers[1] != null)
              _buildResultCard(),
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
    return DragTarget<int>(
      onWillAcceptWithDetails: (data) => selectedNumbers[index] == null,
      onAcceptWithDetails: (details) {
        setState(() {
          selectedNumbers[index] = details.data; // Extracting the integer value
        });
        _updateCombination();
      },
      builder: (context, candidateData, rejectedData) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Brown box instead of tree stump
            Container(
              width: 90,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink, width: 4), // Pink border
              ),
            ),
            // Number Displayed on Drop Target
            if (selectedNumbers[index] != null)
              Text(
                selectedNumbers[index].toString(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // 🟢 Change from white to black for visibility
                ),
              ),
          ],
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
      alignment: Alignment.center,
      child: number != null
          ? Text(
        number.toString(),
        style: const TextStyle(fontSize: 32, color: Colors.white),
      )
          : null,
    );
  }

  Widget _buildResultCard() {
    String combinedNumber = "${selectedNumbers[0]}${selectedNumbers[1]}";
    return Positioned(
      top: 290, // Adjust to control how high it floats
      left: MediaQuery.of(context).size.width / 2 - 60, // Center it
      child: Container(
        width: 120,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.yellow.shade300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 5), // Floating effect
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          combinedNumber,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}