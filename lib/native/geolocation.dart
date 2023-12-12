import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

enum PermissionStatus {
  unknown, //inicial
  granted, //al dar el acceso con el diaolog
  denied, //Cuando se le piden pero nno nos da acceso
  restricted, //si previamente rechazamos el diialogo de eprmissos, ya no deja mosrtarlo , a menos que lo pidaos otraves configurandolo maualmente
}

class Geolocation {
  Geolocation._internal();
  static final Geolocation _instance = Geolocation._internal();
  static Geolocation get instance => _instance;
  final _channel = const MethodChannel("app.meli/geolocation");
  final _event = const EventChannel("app.meli/geolocation");

  late StreamSubscription _subscription;
  RxString _location = "".obs;
  RxString get location => _location;

  void init() {
    _subscription = _event.receiveBroadcastStream().listen((event) {
      _location.value = "${event['lat']}, ${event['lng']}";
      print(event);
    });
  }

  dispose() {
    _subscription.cancel();
  }

  Future<PermissionStatus> checkPermission() async {
    //Obteniendo respuesta del codigo nativo
    final String? result = await _channel.invokeMethod<String>('check');
    return _getStatus(result);
  }

  requestPermission() async {
    final String? result = await _channel.invokeMethod<String>("request");
    return _getStatus(result);
  }

  Future<void> start() async {
    _channel.invokeMethod("start");
  }

  Future<void> stop() async {
    _channel.invokeMethod("stop");
  }

  PermissionStatus _getStatus(String? result) {
    switch (result) {
      case "granted":
        return PermissionStatus.granted;
      case "denied":
        return PermissionStatus.denied;
      case "restricted":
        return PermissionStatus.restricted;
      default:
        return PermissionStatus.restricted;
    }
  }
}
