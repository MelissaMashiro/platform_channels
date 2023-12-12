import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:platform_channels/native/geolocation.dart';
import 'package:platform_channels/pages/home_page.dart';
import 'package:platform_channels/pages/request_page.dart';
import 'package:platform_channels/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
      //home: const HomeExamplePage(),
      onInit: () {
        //para poder escuchar los cambios en la ubicacion del dispositivo
        Geolocation.instance.init();
      },
      onDispose: () {
        Geolocation.instance.dispose();
      },
      routes: {
        'home': (_) => HomePage(),
        'request': (_) => RequestPage(),
      },
    );
  }
}
