import 'dart:convert';
import 'package:chat_test/mogene_response_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'chat_model.dart';

class ChatViewModel extends ChangeNotifier {
  final List<Chat> messages = [];
  bool isLoading = false;

  late final TextEditingController textEditingController =
  TextEditingController();

  void addMessageSent(String message) {
    messages.add(Chat.sent(message));
    notifyListeners();
  }

  void addMessageReceived(String comment) {
    messages.add(Chat.received(comment));
    notifyListeners();
  }

  void addMessageReceivedIndustry(String industry) {
    messages.add(Chat.industry(industry));
    notifyListeners();
  }

  void addMessageReceivedSummary(String summary) {
    messages.add(Chat.summary(summary));
    notifyListeners();
  }

  Future<void> sendMessage(String messageText) async {
    isLoading = true;
    notifyListeners();

    addMessageSent(messageText);
    final Uri uri = Uri.parse('http://ai.mofin.co.kr/mogene/chat');
    try {
      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          "message": messageText,
          "language": "Korean" // 한국어나 영어 둘 중 하나로 설정하면 되는데, 변수는 추후 적용 예정
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
        json.decode(utf8.decode(response.bodyBytes));
        final MogeneResponseData mogeneResponse =
        MogeneResponseData.fromJson(data);

        addMessageReceived(mogeneResponse.comment!);
        for (var i in mogeneResponse.relatedIndustry!) {
          addMessageReceivedIndustry(i.industry);
          addMessageReceivedSummary(i.summary);
        }
      } else {
        print('Server error: ${response.statusCode}');
        addMessageReceived("Mogene was busy and forgot to process your request. Please try again.");
      }
    } catch (e) {
      print('Error sending message: $e');
      addMessageReceived("메시지 전송 중 에러가 발생했습니다.");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
