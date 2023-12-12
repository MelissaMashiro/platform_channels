import 'package:get/get.dart';
import 'package:platform_channels/native/geolocation.dart';

class RequestController extends GetxController {
  Future<void> request() async {
    final PermissionStatus status =
        await Geolocation.instance.requestPermission();

    if (status == PermissionStatus.granted) {
      Get.offNamed('home');
    } else {}
  }
}
