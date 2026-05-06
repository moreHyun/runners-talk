import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/runners_theme.dart';

void main() {
  runApp(const RunnersApp());
}

class RunnersApp extends StatelessWidget {
  const RunnersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '러너스톡',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
