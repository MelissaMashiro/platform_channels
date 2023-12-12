import 'package:get/get.dart';
import 'package:platform_channels/native/geolocation.dart';

class SplashController extends GetxController {
  //Se ejecuta cuando el widget YA fue renderizado completamente
  @override
  void onReady() {
    super.onReady();
    //comprobar acceso
    //SI tenemos acceso, llevar  a home
    //NO tenemos acceso, llevar a request page y mostrar dialogo
    _init();
  }

  void _init() async {
    await Future.delayed(Duration(seconds: 2));
    final PermissionStatus status =
        await Geolocation.instance.checkPermission();

    if (status == PermissionStatus.granted) {
      //go to Home
      // navigator?.pushReplacementNamed('home'); proabr esto
      Get.offNamed('home');  
    } else {
      //go to request
      Get.offNamed('request');
    }
  }
}
