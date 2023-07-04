import 'package:flutter/material.dart';

import '../../models/BananaChatModel.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import './TextWidget.dart';

class ChatWidget extends StatefulWidget {

  const ChatWidget({Key? key, required this.msg, required this.isCures, required this.chatIndex, required this.dropdownData}) : super(key: key);

  final bool isCures;
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
                                      width: 100,
                                      height: 100,
                                      child:  widget.msg[index]['img'] != null
                                          // ?  Image(image: NetworkImage(widget.msg[index]['img']))
                                          ? Image.network(
                                              widget.msg[index]['img'].toString(),
                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                return const Text('Image not found', style: TextStyle(color: Colors.red),);
                                              },
                                            )
                                          : Image.asset(AppImages.logoTW),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                            ),
                          if (widget.isCures)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_circle_left_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Swipe left to try another method',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
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
