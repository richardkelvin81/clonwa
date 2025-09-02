import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:myapp/data/models/chat.dart';
import 'package:myapp/data/models/message.dart';
import 'package:myapp/data/repositories/chat_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado del chat
class ChatState {
  final List<Chat> chats;
  final List<Message> messages;
  final bool isRecording;
  final String? filePath;
  final String? downloadUrl;

  const ChatState({
    this.chats = const [],
    this.messages = const [],
    this.isRecording = false,
    this.filePath,
    this.downloadUrl,
  });

  ChatState copyWith({
    List<Chat>? chats,
    List<Message>? messages,
    bool? isRecording,
    String? filePath,
    String? downloadUrl,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      messages: messages ?? this.messages,
      isRecording: isRecording ?? this.isRecording,
      filePath: filePath ?? this.filePath,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }
}

/// Notifier para manejar la lógica del chat
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _chatRepository;
  final FirebaseStorage _storage;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  Timer? _recordTimer;

  ChatNotifier({
    required ChatRepository chatRepository,
    FirebaseStorage? storage,
  })  : _chatRepository = chatRepository,
        _storage = storage ?? FirebaseStorage.instance,
        super(const ChatState()) {
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
  }

  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
  }

  /// Obtener chats
  void getChats() {
    _chatRepository.getChats().listen((chats) {
      state = state.copyWith(chats: chats);
    });
  }

  /// Obtener mensajes
  void getMessages(String chatId) {
    _chatRepository.getMessages(chatId).listen((messages) {
      state = state.copyWith(messages: messages);
    });
  }

  /// Enviar mensaje de texto
  Future<void> sendMessage(String chatId, String text) async {
    final message = Message(
      id: '',
      senderId: 'user1', // reemplazar
      text: text,
      timestamp: DateTime.now(),
      isRead: false,
    );
    await _chatRepository.sendMessage(chatId, message);
  }

  /// Iniciar grabación
  Future<void> startRecording() async {
    if (state.isRecording) return;

    final hasPerm = await _checkPermissions();
    if (!hasPerm) return;

    final filePath = await _getFilePath();

    try {
      await _recorder.startRecorder(
        toFile: filePath,
        codec: Codec.aacMP4,
        sampleRate: 16000,
      );

      state = state.copyWith(isRecording: true, filePath: filePath);

      _recordTimer?.cancel();
      _recordTimer = Timer(const Duration(seconds: 30), () async {
        if (state.isRecording) await stopRecording();
      });
    } catch (e) {
      debugPrint('Error al iniciar grabación: $e');
    }
  }

  /// Detener grabación
  Future<void> stopRecording() async {
    if (!state.isRecording) return;

    try {
      await _recorder.stopRecorder();
      _recordTimer?.cancel();
      state = state.copyWith(isRecording: false);
    } catch (e) {
      debugPrint('Error al detener grabación: $e');
    }
  }

  /// Enviar audio
  Future<void> sendAudioMessage(String chatId) async {
    if (state.filePath == null) return;

    try {
      final file = File(state.filePath!);
      if (!file.existsSync()) return;

      final ref = _storage
          .ref()
          .child('audios/${DateTime.now().millisecondsSinceEpoch}.aac');

      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      final message = Message(
        id: '',
        senderId: 'user1',
        text: '',
        timestamp: DateTime.now(),
        isRead: false,
        audioUrl: url,
      );

      await _chatRepository.sendMessage(chatId, message);

      state = state.copyWith(filePath: null, downloadUrl: url);
    } catch (e) {
      debugPrint('Error enviando audio: $e');
    }
  }

  void updateMessageReadStatus(String chatId, String messageId) {
    _chatRepository.updateMessageReadStatus(chatId, messageId);
  }

  Future<bool> _checkPermissions() async {
    final micStatus = await Permission.microphone.request();
    return micStatus.isGranted;
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _recordTimer?.cancel();
    super.dispose();
  }
}

/// Provider global
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(chatRepository: ChatRepository());
});
