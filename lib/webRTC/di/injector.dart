import 'package:get_it/get_it.dart';
import 'package:varta/webRTC/di/cubit_module.dart';
import 'package:varta/webRTC/di/data_source_module.dart';
import 'package:varta/webRTC/di/interactor_module.dart';
import 'package:varta/webRTC/di/repository_module.dart';

GetIt get i => GetIt.instance;

void initInjector() {
  initDataSourceModule();
  initRepositoryModule();
  initInteractorModule();
  initCubitModule();
}
