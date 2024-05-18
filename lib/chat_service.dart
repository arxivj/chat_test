import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chat_test/mogene_response_data.dart';
import 'package:chat_test/industry_model.dart';

class ChatService {
  final String baseUrl;

  ChatService({required this.baseUrl});

  Future<MogeneResponseData?> sendMessage(String messageText) async {
    final Uri uri = Uri.parse('$baseUrl/chat');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({"message": messageText, "language": "Korean"}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return MogeneResponseData.fromJson(data);
      } else {
        print('Server error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }

  Future<List<IndustryModel>?> fetchRecommendation(String industry) async {
    final Uri uri = Uri.parse('$baseUrl/recommend?industry=$industry');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse.take(3).map<IndustryModel>((data) => IndustryModel.fromJson(data)).toList();
      } else {
        print('Server error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching recommendation: $e');
      return null;
    }
  }
}
