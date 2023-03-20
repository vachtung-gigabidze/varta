import 'package:varta/di/injector.dart';
import 'package:varta/domain/interactors/webrtc_interactor.dart';

void initInteractorModule() {
  i.registerFactory<WebrtcInteractor>(() => WebrtcInteractor(i.get()));
}
