import 'package:flutter/services.dart';

class PlatformChannel {
  final MethodChannel _methodChannel = MethodChannel(
      'app.meli/my_platform_channel'); //nombre opcional, solo tener cuidado q no se repita cn el de algun plugin que use la app

  Future<void> version() async {
    try {
      final result = await _methodChannel.invokeMethod('version');
      print('version --> $result');
    } catch (e) {
      print("Error --> $e");
    }
  }
}
