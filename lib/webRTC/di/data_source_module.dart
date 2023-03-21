import 'package:varta/webRTC/data/datasources/remote_datasource.dart';
import 'package:varta/webRTC/di/injector.dart';

void initDataSourceModule() {
  i.registerSingleton<RemoteDataSource>(
    RemoteDataSource(),
  );
}
