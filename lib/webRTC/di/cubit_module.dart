import 'package:varta/webRTC/di/injector.dart';
import 'package:varta/webRTC/presentation/pages/webrtc/webrtc_cubit.dart';

void initCubitModule() {
  i.registerFactory<WebrtcCubit>(() => WebrtcCubit(i.get()));
}
