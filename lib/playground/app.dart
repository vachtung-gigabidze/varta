import 'package:flutter/material.dart';
import 'package:varta/playground/pages/playground_page.dart';

class VartaApp extends StatelessWidget {
  const VartaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlaygroundPage(),
    );
  }
}
