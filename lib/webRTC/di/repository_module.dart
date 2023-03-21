import 'package:varta/webRTC/data/repositories/auth_repository.dart';
import 'package:varta/webRTC/data/repositories/room_repository.dart';
import 'package:varta/webRTC/di/injector.dart';
import 'package:varta/webRTC/domain/repositories/auth_repository.dart';
import 'package:varta/webRTC/domain/repositories/room_repository.dart';

void initRepositoryModule() {
  i.registerSingleton<RoomRepositoryInt>(RoomRepository(i.get()));
  i.registerSingleton<AuthRepositoryInt>(AuthRepository(i.get()));
}
