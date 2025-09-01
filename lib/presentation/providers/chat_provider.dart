import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:myapp/data/models/chat.dart';
import 'package:myapp/data/models/message.dart';
import 'package:myapp/data/repositories/chat_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';


class ChatProvider with ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();
  final Record _audioRecorder = Record();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<Chat> _chats = [];
  List<Message> _messages = [];
  bool _isRecording = false;

  List<Chat> get chats => _chats;
  List<Message> get messages => _messages;
  bool get isRecording => _isRecording;

  void getChats() {
    _chatRepository.getChats().listen((chats) {
      _chats = chats;
      notifyListeners();
    });
  }

  void getMessages(String chatId) {
    _chatRepository.getMessages(chatId).listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  Future<void> sendMessage(String chatId, String text) async {
    final message = Message(
      id: '',
      senderId: 'user1', // Replace with actual user ID
      text: text,
      timestamp: DateTime.now(),
      isRead: false,
    );
    await _chatRepository.sendMessage(chatId, message);
  }

  Future<void> sendAudioMessage(String chatId) async {
    if (await _audioRecorder.isRecording()) {
      final path = await _audioRecorder.stop();
      if (path != null) {
        final file = File(path);
        final ref = _storage.ref().child('audio/${DateTime.now()}.m4a');
        final uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() => null);
        final downloadUrl = await snapshot.ref.getDownloadURL();

        final message = Message(
          id: '',
          senderId: 'user1', // Replace with actual user ID
          text: '',
          timestamp: DateTime.now(),
          isRead: false,
          audioUrl: downloadUrl,
        );
        await _chatRepository.sendMessage(chatId, message);
      }
      _isRecording = false;
      notifyListeners();
    }
  }

  Future<void> startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      await _audioRecorder.start();
      _isRecording = true;
      notifyListeners();
    }
  }

  void updateMessageReadStatus(String chatId, String messageId) {
    _chatRepository.updateMessageReadStatus(chatId, messageId);
  }
}
