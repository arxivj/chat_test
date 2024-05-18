import 'package:flutter/material.dart';

import 'chat_model.dart';
import 'formatter.dart';
import 'message_type.dart';

class ChatContentsWidget extends StatelessWidget {
  final Chat chat;

  ChatContentsWidget({required this.chat});

  @override
  Widget build(BuildContext context) {
    CrossAxisAlignment crossAlignmentOnType = chat.type == MessageType.user
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    Color textColorOnType = chat.type == MessageType.user
        ? Colors.black
        : Colors.orange;

    return Column(
      crossAxisAlignment: crossAlignmentOnType,
      children: [
        if (chat.message != null)
          Text(
            chat.message!,
            style: TextStyle(color: textColorOnType),
          ),
        if(chat.comment != null)
          Text(
            chat.comment!,
            style: TextStyle(color: Colors.blue),
          ),
        if (chat.industry != null)
          InkWell(
            onTap: () {
              print('Industry: ${chat.industry}');
              // 여기에 클릭시 industry에 대한 정보를 ai 서버에 요청하는 메서드 ㄱ
            },
            child: Container(
              width: double.infinity,
              height: 20,
              child: Text(
                chat.industry!,
                style: TextStyle(color: Colors.green,
                  decoration: TextDecoration.underline,

                ),
              ),
            ),
          ),
        if (chat.summary != null)
          Text(
            chat.summary!,
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}