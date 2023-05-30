import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_images.dart';
import './TextWidget.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key, required this.msg, required this.chatIndex}) : super(key: key);

  final String msg;
  final int chatIndex;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: widget.chatIndex == 0 ? AppColors.chatScaffoldBackgroundColor : AppColors.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  widget.chatIndex == 0 ? AppImages.userImage : AppImages.botImage,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: widget.chatIndex == 0
                      ? TextWidget(label: widget.msg)
                      : DefaultTextStyle(
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                            child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              repeatForever: false,
                              displayFullTextOnTap: true,
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TyperAnimatedText(widget.msg.trim()),
                              ],
                            ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
