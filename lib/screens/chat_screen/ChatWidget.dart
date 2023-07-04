import 'package:flutter/material.dart';

import '../../models/BananaChatModel.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import 'TextWidget.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key, required this.msg, required this.chatIndex, required this.dropdownData}) : super(key: key);

  final dynamic msg;
  final int chatIndex;
  final List<Diseases> dropdownData;

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
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.msg.runtimeType == String)
                            TextWidget(label: widget.msg.trim())
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.msg.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.msg[index]['name_display'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      widget.msg[index]['description'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: 150,
                                      height: 150,
                                      child:  widget.msg[index]['img'] != null
                                          ?  Image(image: NetworkImage(widget.msg[index]['img']))
                                          : Image.asset(AppImages.logoTW),
                                    )
                                  ],
                                );
                              },
                            ),
                          /// showing dynamic data ===================
                          // if (widget.dropdownData.isNotEmpty)
                          //   ListView.builder(
                          //     shrinkWrap: true,
                          //     itemCount: widget.dropdownData.length,
                          //     itemBuilder: (context, index) {
                          //       return TextWidget(label: widget.dropdownData[index].nameDisplay!);
                          //     },
                          //   ),
                        ],
                      ), // WITHOUT TYPING ANIMATION
                      // : DefaultTextStyle(
                      //       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                      //       child: AnimatedTextKit(
                      //         isRepeatingAnimation: false,
                      //         repeatForever: false,
                      //         displayFullTextOnTap: true,
                      //         totalRepeatCount: 1,
                      //         animatedTexts: [
                      //           TyperAnimatedText(widget.msg.trim()),
                      //         ],
                      //       ),
                      //   ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
