import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'chat_model.dart';
import 'chat_view_model.dart';
import 'message_type.dart';

class ChatContentsWidget extends StatelessWidget {
  final Chat chat;
  final ScrollController scrollController;

  const ChatContentsWidget({super.key, 
    required this.chat,
    required this.scrollController,
  });

  Future<void> scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _isValidJson(String str) {
    try {
      json.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisAlignment = chat.type == MessageType.user
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final textColor = chat.type == MessageType.user
        ? Colors.black
        : Colors.orange;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (chat.message != null && chat.message!.isNotEmpty)
          _buildMessageContent(context, chat.message!, textColor),
        if (chat.comment != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              chat.comment!,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        if (chat.industry != null)
          _buildIndustryContent(context),
        if (chat.summary != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              chat.summary!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageContent(BuildContext context, String message, Color textColor) {
    if (_isValidJson(message)) {
      final decodedMessage = json.decode(message);
      final messageType = decodedMessage['type'];

      if (messageType == 'file') {
        return _buildFileMessage(context, decodedMessage);
      } else if (messageType == 'image') {
        return _buildImageMessage(decodedMessage);
      }
    }

    return Text(
      message,
      style: TextStyle(color: textColor),
    );
  }

  Widget _buildFileMessage(BuildContext context, Map<String, dynamic> decodedMessage) {
    return InkWell(
      onTap: () {
        var fileMessage = types.FileMessage.fromJson(decodedMessage);
        context.read<ChatViewModel>().handleMessageTap(fileMessage);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          'File: ${decodedMessage['name']}',
          style: const TextStyle(
            color: Colors.green,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildImageMessage(Map<String, dynamic> decodedMessage) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Image.file(File(decodedMessage['uri'])),
    );
  }

  Widget _buildIndustryContent(BuildContext context) {
    return InkWell(
      onTap: () async {
        print('Industry: ${chat.industry}');
        context.read<ChatViewModel>().fetchRecommendation(chat.industry!);
        await scrollToBottom();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          chat.industry!,
          style: const TextStyle(
            color: Colors.green,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
