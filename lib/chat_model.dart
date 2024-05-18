import 'message_type.dart';
import 'mogene_response_data.dart';

class Chat {
  final String? message;
  final MessageType type;
  final DateTime time;
  final List<RelatedIndustry>? relatedIndustry;
  final String? comment;
  final String? industry;
  final String? summary;

  // final List<IndustryInfo>? recommendations;

  Chat(
      {this.message,
      required this.type,
      required this.time,
      this.relatedIndustry,
      this.comment,
      this.industry,
      this.summary});

  factory Chat.sent(String message) {
    return Chat(message: message, type: MessageType.user, time: DateTime.now());
  }

  factory Chat.received(String comment) {
    return Chat(comment: comment, type: MessageType.bot, time: DateTime.now());
  }

  factory Chat.industry(String industry) {
    return Chat(
        industry: industry, type: MessageType.bot, time: DateTime.now());
  }

  factory Chat.summary(String summary) {
    return Chat(summary: summary, type: MessageType.bot, time: DateTime.now());
  }
}
