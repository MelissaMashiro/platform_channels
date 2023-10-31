import 'package:flutter/material.dart';
import 'package:platform_channels/native/platform_channel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('GET VERSION'),
          onPressed: () {
            PlatformChannel _platformChannel = PlatformChannel();
            _platformChannel.version();
          },
        ),
      ),
    );
  }
}
