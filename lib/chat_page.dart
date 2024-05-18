import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bubble.dart';
import 'chat_view_model.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    Future<void> scrollToBottom() async {
      await Future.delayed(const Duration(milliseconds: 100));
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(baseUrl: 'http://ai.mofin.co.kr/mogene'),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Chat Test'),
          backgroundColor: Colors.teal.shade500,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel_sharp),
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
                  child: Consumer<ChatViewModel>(
                    builder: (context, chatViewModel, child) {
                      final messages = chatViewModel.messages.reversed.toList();
                      return ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return Bubble(chat: messages[index], scrollController: scrollController);
                        },
                      );
                    },
                  ),
                ),
              ),
              Consumer<ChatViewModel>(
                builder: (context, chatViewModel, child) {
                  return Column(
                    children: [
                      if (chatViewModel.isLoading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      _buildInputField(context, chatViewModel),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, ChatViewModel chatViewModel) {
    TextEditingController textEditingController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.teal.shade500),
            onPressed: chatViewModel.isLoading ? null : () => _showAttachmentOptions(context),
          ),
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
              ),
              onSubmitted: chatViewModel.isLoading
                  ? null
                  : (String messageText) {
                if (messageText.isNotEmpty) {
                  chatViewModel.sendMessage(messageText);
                  textEditingController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
              enabled: !chatViewModel.isLoading,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.teal.shade500),
            onPressed: chatViewModel.isLoading
                ? null
                : () {
              final messageText = textEditingController.text.trim();
              if (messageText.isNotEmpty) {
                chatViewModel.sendMessage(messageText);
                textEditingController.clear();
                FocusScope.of(context).unfocus();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(bottomSheetContext);
                    context.read<ChatViewModel>().handleImageSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(bottomSheetContext);
                    context.read<ChatViewModel>().handleFileSelection();
                  },
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('File'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(bottomSheetContext),
                  child: const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
