import 'package:codebuddy/screen/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeMate By Ladle',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Colors.teal, // Primary color
          secondary: Colors.amber, // Secondary color
          surface: Colors.white, // Background color
          error: Colors.red, // Error color
          onPrimary: Colors.white, // Text color on primary
          onSecondary: Colors.black, // Text color on secondary
          onSurface: Colors.black, // Text color on background
          onError: Colors.white, // Text color on error
          brightness: Brightness.light, // Light theme
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}
