import 'package:get/get.dart';
import 'package:platform_channels/native/geolocation.dart';

class HomeController extends GetxController {
  bool _tracking = false;
  bool get tracking => _tracking;
  
  Future<void> startTracking() async {
    await Geolocation.instance.start();
    _tracking = true;
    update(['tracking']);
  }

  Future<void> stopTracking() async {
    await Geolocation.instance.stop();
    _tracking = false;
    update(['tracking']);
  }
}
