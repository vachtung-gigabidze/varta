import 'package:get_it/get_it.dart';
import 'package:varta/di/cubit_module.dart';
import 'package:varta/di/data_source_module.dart';
import 'package:varta/di/interactor_module.dart';
import 'package:varta/di/repository_module.dart';

GetIt get i => GetIt.instance;

void initInjector() {
  initDataSourceModule();
  initRepositoryModule();
  initInteractorModule();
  initCubitModule();
}
