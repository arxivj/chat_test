import 'message_type.dart';
import 'mogene_response_data.dart';

class Chat{
  final String message;
  final MessageType type;
  final DateTime time;
  final List<RelatedIndustry>? relatedIndustry;
  // final List<IndustryInfo>? recommendations;

  Chat({required this.message,required this.type, required this.time, this.relatedIndustry});

  factory Chat.sent(String message){
    return Chat(message: message, type: MessageType.user, time: DateTime.now());
  }

  factory Chat.received(String message, List<RelatedIndustry>? relatedIndustry) {
    return Chat(message: message, relatedIndustry: relatedIndustry, type: MessageType.bot, time: DateTime.now());
  }

  // 더미데이터인데, 서비스에서 서버로 부터 받아온 데이터를 가져와서 사용할꺼
  static List<Chat> generate(){
    return [
      Chat(message: 'Hello', type: MessageType.bot, time: DateTime.now().subtract(Duration(minutes: 5))),
      Chat(message: 'Hi', type: MessageType.user, time: DateTime.now().subtract(Duration(minutes: 4))),
      Chat(message: 'How are you?', type: MessageType.user, time: DateTime.now().subtract(Duration(minutes: 3))),
      Chat(message: 'I am fine', type: MessageType.bot, time: DateTime.now().subtract(Duration(minutes: 2))),
      Chat(message: 'Good to hear that', type: MessageType.user, time: DateTime.now().subtract(Duration(minutes: 1))),
    ];
  }


}