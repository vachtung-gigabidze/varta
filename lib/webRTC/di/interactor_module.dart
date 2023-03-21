import 'package:varta/webRTC/di/injector.dart';
import 'package:varta/webRTC/domain/interactors/webrtc_interactor.dart';

void initInteractorModule() {
  i.registerFactory<WebrtcInteractor>(() => WebrtcInteractor(i.get()));
}
