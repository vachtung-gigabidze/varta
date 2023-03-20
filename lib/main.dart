import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:varta/di/injector.dart';
import 'package:varta/domain/repositories/auth_repository.dart';
import 'package:varta/presentation/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initInjector();
  await i.get<AuthRepositoryInt>().signInAnonymously();
  runApp(const VideoStreamingApp());
}
