import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key? key, this.msg}) : super(key: key);
  final String? msg;
  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
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
                 widget.msg != null
                     ? widget.msg.toString()
                     : 'Processing...',
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
