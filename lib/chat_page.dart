import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bubble.dart';
import 'chat_model.dart';
import 'chat_view_model.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    Future<void> scrollToBottom() async {
      await Future.delayed(Duration(milliseconds: 100));
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Chat Test'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.cancel_sharp),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Selector<ChatViewModel, List<Chat>>(
                  selector: (context, chatViewModel) =>
                      chatViewModel.messages.reversed.toList(),
                  builder: (BuildContext context, List<Chat> messages, Widget? child) {
                    return ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Bubble(chat: messages[index]);
                      },
                    );
                  },
                ),
              ),
            ),
            Selector<ChatViewModel, bool>(
              selector: (context, chatViewModel) => chatViewModel.isLoading,
              builder: (context, isLoading, child) {
                return Column(
                  children: [
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    _buildInputField(context, isLoading),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, bool isLoading) {
    TextEditingController textEditingController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: isLoading
                  ? null
                  : (String messageText) {
                if (messageText.isNotEmpty) {
                  context.read<ChatViewModel>().sendMessage(messageText);
                  textEditingController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
              enabled: !isLoading,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: isLoading
                ? null
                : () {
              final messageText = textEditingController.text.trim();
              if (messageText.isNotEmpty) {
                context.read<ChatViewModel>().sendMessage(messageText);
                textEditingController.clear();
                FocusScope.of(context).unfocus();
              }
            },
          ),
        ],
      ),
    );
  }
}
