import 'package:flutter/material.dart';

class SplashCreen extends StatelessWidget {
  const SplashCreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CircularProgressIndicator.adaptive(),
      )
    );
  }
}
