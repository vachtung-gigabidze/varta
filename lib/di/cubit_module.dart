import 'package:varta/di/injector.dart';
import 'package:varta/presentation/pages/webrtc/webrtc_cubit.dart';

void initCubitModule() {
  i.registerFactory<WebrtcCubit>(() => WebrtcCubit(i.get()));
}
