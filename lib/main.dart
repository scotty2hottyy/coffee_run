// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const CoffeeRunApp());
}

class CoffeeRunApp extends StatelessWidget {
  const CoffeeRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee Run',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}