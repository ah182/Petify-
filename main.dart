
import 'package:flutter/material.dart';

void main() {
  runApp(const PetifyApp());
}

class PetifyApp extends StatelessWidget {
  const PetifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petify',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Petify 🐾')),
      body: const Center(child: Text('Welcome to Petify!', style: TextStyle(fontSize: 24))),
    );
  }
}
