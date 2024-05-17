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
        0, // Scroll to the start, reverse scroll means bottom
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true, // Avoid keyboard covering the input
      appBar: AppBar(
        title: Text('Chat Test'),
        backgroundColor: Colors.teal,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard
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
                    return ListView.separated(
                      controller: scrollController,
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Bubble(chat: messages[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          color: Colors.transparent,
                          height: 3,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            _buildInputField(context),
          ],
        ),
      ),
    );
  }
}

Widget _buildInputField(BuildContext context) {
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
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            final messageText = textEditingController.text.trim();
            if (messageText.isNotEmpty) {
              context.read<ChatViewModel>().sendMessage(messageText);
              textEditingController.clear();
              FocusScope.of(context).unfocus(); // Dismiss the keyboard
            }
          },
        ),
      ],
    ),
  );
}
