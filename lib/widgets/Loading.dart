import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SpinKitRing(
            size: 40,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 30,
            child: AnimatedTextKit(
              animatedTexts: [
                RotateAnimatedText(
                  'Processing...',
                  textStyle: const TextStyle(color: Colors.white),
                ),
                RotateAnimatedText(
                  'Please wait...',
                  textStyle: const TextStyle(color: Colors.white),
                ),
              ],
              repeatForever: true,
            ),
          ),
        ],
      ),
    );
  }
}
