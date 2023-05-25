// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:varta/playground/app.dart';
import 'package:varta/playground/pages/varta_game.dart';
// import 'package:varta/webRTC/di/injector.dart';
// import 'package:varta/webRTC/domain/repositories/auth_repository.dart';
// import 'package:varta/webRTC/firebase_options.dart';
// import 'package:varta/webRTC/presentation/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // //await Firebase.initializeApp();
  // initInjector();
  // await i.get<AuthRepositoryInt>().signInAnonymously();
  // runApp(const VideoStreamingApp());
  // runApp(const VartaApp());
  runApp(const VartaGame());
}
