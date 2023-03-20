import 'package:varta/data/repositories/auth_repository.dart';
import 'package:varta/data/repositories/room_repository.dart';
import 'package:varta/di/injector.dart';
import 'package:varta/domain/repositories/auth_repository.dart';
import 'package:varta/domain/repositories/room_repository.dart';

void initRepositoryModule() {
  i.registerSingleton<RoomRepositoryInt>(RoomRepository(i.get()));
  i.registerSingleton<AuthRepositoryInt>(AuthRepository(i.get()));
}
