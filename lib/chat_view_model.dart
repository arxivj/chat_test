import 'dart:convert';
import 'package:chat_test/mogene_response_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'chat_model.dart';

class ChatViewModel extends ChangeNotifier {
  final List<Chat> messages = [];

  late final TextEditingController textEditingController =
      TextEditingController();

  void addMessage(String message) {
    messages.add(Chat.sent(message));
    notifyListeners();
  }

  Future<void> sendMessage(String messageText) async {
    print('Sending message: $messageText');
    final Uri uri = Uri.parse('http://ai.mofin.co.kr/mogene/chat');
    try {
      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          "message": messageText,
          "language": "English" // 한국어나 영어 둘 중 하나로 설정하면 되는데, 변수는 추후 적용 예정
        }),
      );
      print("dfdsfsdfsdf");
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));
        final MogeneResponseData mogeneResponse =
            MogeneResponseData.fromJson(data);
        print("dfdsfsdsfsdfsdfsdfdfsdf");
        // 받아온 JSON 객체를 리스트에 넣고
        // ChatMessage 객체를 만들어서 messages 리스트에 추가

        // 이젠ㅇ

        print('하나님, 아버지!!!!! : ${mogeneResponse.comment}');
        for (var i in mogeneResponse.relatedIndustry!) {
          print('하아 시바신시이여, 제발 작동하게 해주세용: ${i.industry}');
          print('하아 시바신: ${i.summary}');
        }

        // 위 i.industry, i.summary를 이용해서 Chat.sent()를 이용해 Chat 객체를 만들어 messages 리스트에 추가

      } else {
        print('Server error: ${response.statusCode}');
        addMessage("서버에서 데이터를 받아오는 데 실패했습니다.");
      }
    } catch (e) {
      print('Error sending message: $e');
      addMessage("메시지 전송 중 에러가 발생했습니다.");
    }
  }
}
