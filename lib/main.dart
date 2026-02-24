import 'package:flutter/material.dart';
import 'package:campzoo/screens/intro_screen.dart';

void main() {
  runApp(const CampZooApp());
}

class CampZooApp extends StatelessWidget {
  const CampZooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampZoo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const IntroScreen(),
    );
  }
}
