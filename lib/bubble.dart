import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'chat_contents_widget.dart';
import 'chat_model.dart';
import 'formatter.dart';
import 'message_type.dart';

class Bubble extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Chat chat;

  const Bubble({
    super.key,
    this.margin,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignmentOnType,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (chat.type == MessageType.bot && chat.message != null)
        //   const CircleAvatar(
        //     backgroundImage: AssetImage("assets/images/avatar_1.png"),
        //   ),
        Container(
          margin: margin ?? EdgeInsets.zero,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            // padding: paddingOnType,
            child: Column(
              crossAxisAlignment: crossAlignmentOnType,
              children: [
                ChatContentsWidget(chat: chat),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color get textColorOnType {
    switch (chat.type) {
      case MessageType.user:
        return Colors.red;
      case MessageType.bot:
        return Colors.blue;
    }
  }

  Color get bgColorOnType {
    switch (chat.type) {
      case MessageType.bot:
        return Colors.black;
      case MessageType.user:
        return const Color(0xFF007AFF);
    }
  }

  // CustomClipper<Path> get clipperOnType {
  //   switch (chat.type) {
  //     case MessageType.user:
  //       return ChatBubbleClipper1(type: BubbleType.sendBubble);
  //     case MessageType.bot:
  //       return ChatBubbleClipper1(type: BubbleType.receiverBubble);
  //   }
  // }

  CrossAxisAlignment get crossAlignmentOnType {
    switch (chat.type) {
      case MessageType.user:
        return CrossAxisAlignment.end;
      case MessageType.bot:
        return CrossAxisAlignment.start;
    }
  }

  MainAxisAlignment get alignmentOnType {
    switch (chat.type) {
      case MessageType.bot:
        return MainAxisAlignment.start;

      case MessageType.user:
        return MainAxisAlignment.end;
    }
  }

  EdgeInsets get paddingOnType {
    switch (chat.type) {
      case MessageType.user:
        return const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 24);
      case MessageType.bot:
        return const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 24,
          right: 10,
        );
    }
  }
}