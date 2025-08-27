import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const VoltMateApp());
}

class VoltMateApp extends StatelessWidget {
  const VoltMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoltMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
