import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:platform_channels/controllers/request_controller.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestController>(
        init: RequestController(),
        builder: (requestController) {
          return Scaffold(
            body: SafeArea(
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    CupertinoButton(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(30.0),
                      onPressed: () {
                        requestController.request();
                      },
                      child: const Text(
                        'ALLOW',
                        style: TextStyle(
                          letterSpacing: 1.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
