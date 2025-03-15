import 'package:flutter/material.dart';
import 'pages/start.dart'; // Importing StartPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Topia',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const StartPage(),
    );
  }
}
