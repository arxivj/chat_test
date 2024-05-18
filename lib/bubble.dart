import 'package:flutter/material.dart';
import 'chat_contents_widget.dart';
import 'chat_model.dart';
import 'message_type.dart';

class Bubble extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Chat chat;
  final ScrollController scrollController;

  const Bubble({
    super.key,
    this.margin,
    required this.chat,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: _getMainAxisAlignment(chat.type),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin:
              margin ?? const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: chat.type == MessageType.bot
                ? Colors.grey[200]
                : Colors.blue[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: ChatContentsWidget(
              chat: chat, scrollController: scrollController),
        ),
      ],
    );
  }

  MainAxisAlignment _getMainAxisAlignment(MessageType type) {
    return type == MessageType.bot
        ? MainAxisAlignment.start
        : MainAxisAlignment.end;
  }
}
