import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

import 'chat_model.dart';
import 'chat_service.dart';
import 'message_type.dart';
import 'mogene_response_data.dart';
import 'industry_model.dart';

class ChatViewModel extends ChangeNotifier {
  final List<Chat> messages = [];
  bool isLoading = false;
  late final ChatService chatService;
  late final TextEditingController textEditingController;

  ChatViewModel({required String baseUrl}) {
    chatService = ChatService(baseUrl: baseUrl);
    textEditingController = TextEditingController();
  }

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
    _setLoading(true);
    addMessageSent(messageText);

    final MogeneResponseData? response = await chatService.sendMessage(messageText);
    if (response != null) {
      _processMogeneResponse(response);
    } else {
      addMessageReceived("Mogene was busy and forgot to process your request. Please try again.");
    }

    _setLoading(false);
  }

  void _processMogeneResponse(MogeneResponseData response) {
    addMessageReceived(response.comment!);
    for (var industry in response.relatedIndustry!) {
      addMessageReceivedIndustry(industry.industry);
      addMessageReceivedSummary(industry.summary);
    }
  }

  Future<void> fetchRecommendation(String industry) async {
    _setLoading(true);
    addMessageSent(industry);

    final recommendations = await chatService.fetchRecommendation(industry);
    if (recommendations != null) {
      _processRecommendations(recommendations);
    } else {
      addMessageReceived("Failed to fetch recommendations. Please try again.");
    }

    _setLoading(false);
  }

  void _processRecommendations(List<IndustryModel> recommendations) {
    for (var recommendation in recommendations) {
      final message = 'We recommend ${recommendation.ticker} in the ${recommendation.industry} industry.';
      addMessageReceived(message);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void addMessage(types.Message message) {
    if (message is types.FileMessage || message is types.ImageMessage) {
      messages.add(Chat(
        message: json.encode(message.toJson()),
        type: MessageType.user,
        time: DateTime.now(),
      ));
      notifyListeners();
    }
  }

  Future<void> handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _getUser(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      addMessage(message);
    }
  }

  Future<void> handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _getUser(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      addMessage(message);
    }
  }

  Future<void> handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        localPath = await _downloadFile(message);
      }

      await OpenFilex.open(localPath);
    }
  }

  Future<String> _downloadFile(types.FileMessage message) async {
    final client = http.Client();
    final request = await client.get(Uri.parse(message.uri));
    final bytes = request.bodyBytes;
    final documentsDir = (await getApplicationDocumentsDirectory()).path;
    final localPath = '$documentsDir/${message.name}';

    if (!File(localPath).existsSync()) {
      final file = File(localPath);
      await file.writeAsBytes(bytes);
    }
    return localPath;
  }

  types.User _getUser() {
    return const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  }
}
