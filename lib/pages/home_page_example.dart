import 'package:flutter/material.dart';
import 'package:platform_channels/native/platform_channel_example.dart';

class HomePageExample extends StatelessWidget {
  const HomePageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('GET VERSION'),
          onPressed: () {
            PlatformChannelExample _platformChannel = PlatformChannelExample();
            _platformChannel.version();
          },
        ),
      ),
    );
  }
}
