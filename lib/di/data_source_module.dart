import 'package:varta/data/datasources/remote_datasource.dart';
import 'package:varta/di/injector.dart';

void initDataSourceModule() {
  i.registerSingleton<RemoteDataSource>(
    RemoteDataSource(),
  );
}
