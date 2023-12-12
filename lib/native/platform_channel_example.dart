import 'package:flutter/services.dart';

class PlatformChannelExample {
  final MethodChannel _methodChannel = MethodChannel(
      'app.meli/my_platform_channel'); //nombre opcional, solo tener cuidado q no se repita cn el de algun plugin que use la app

  Future<void> version() async {
    try {
      //sending a string to the host channel
      //final result = await _methodChannel.invokeMethod('version','stringobject');

      //sending a Map
      final result = await _methodChannel.invokeMethod('version', {
        'name': 'Melissa',
        'lastname': 'Alvarez',
        'age': 24,
      });
      print('version --> $result');
    } catch (e) {
      print("Error --> $e");
    }
  }
}
