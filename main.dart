
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petify',
      home: Scaffold(
        appBar: AppBar(title: const Text('Petify 🐾')),
        body: const Center(child: Text('Welcome to Petify!')),
      ),
    );
  }
}
