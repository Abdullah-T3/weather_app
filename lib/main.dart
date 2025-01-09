import 'package:flutter/material.dart';

import 'theming/colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: ColorsManager.primaryColor,
        primaryColor: ColorsManager.primaryColor,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
