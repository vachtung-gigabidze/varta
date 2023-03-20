import 'package:flutter/material.dart';
import 'package:varta/presentation/pages/webrtc/webrtc_page.dart';

class VideoStreamingApp extends StatelessWidget {
  const VideoStreamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebrtcPage(),
    );
  }
}
