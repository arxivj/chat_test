import 'package:chat_test/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Test',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: ChatPage(),
    );
  }
}
