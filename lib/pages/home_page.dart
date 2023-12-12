import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_channels/controllers/home_controller.dart';
import 'package:platform_channels/native/geolocation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (homeController) {
          return Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Text(Geolocation.instance.location.value)),
                  TextButton(
                    child: GetBuilder<HomeController>(
                      id: 'tracking', //para que escuche el update del getx del id q dice tracking
                      builder: (controller) {
                        return Text(
                            "${controller.tracking ? 'STOP' : 'START'} START TRACKING");
                      },
                    ),
                    onPressed: () {
                      if (homeController.tracking) {
                        homeController.stopTracking();
                      } else {
                        homeController.startTracking();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
