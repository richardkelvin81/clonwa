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

class ChatProvider with ChangeNotifier {
  final ChatRepository _chatRepository = ChatRepository();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<Chat> _chats = [];
  List<Message> _messages = [];

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;
  String? _downloadUrl;
  Timer? _recordTimer;

  List<Chat> get chats => _chats;
  List<Message> get messages => _messages;
  bool get isRecording => _isRecording;

  ChatProvider() {
    _initRecorder();
  }

  // Inicializa el recorder
  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
  }

  // Genera ruta para archivo de audio
  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
  }

  // Obtener chats
  void getChats() {
    _chatRepository.getChats().listen((chats) {
      _chats = chats;
      notifyListeners();
    });
  }

  // Obtener mensajes de un chat
  void getMessages(String chatId) {
    _chatRepository.getMessages(chatId).listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }

  // Enviar mensaje de texto
  Future<void> sendMessage(String chatId, String text) async {
    final message = Message(
      id: '',
      senderId: 'user1', // reemplazar por el ID real
      text: text,
      timestamp: DateTime.now(),
      isRead: false,
    );
    await _chatRepository.sendMessage(chatId, message);
  }

  // Inicia grabación
  Future<void> startRecording() async {
    if (_isRecording) return;

    final hasPerm = await _checkPermissions();
    if (!hasPerm) return;

    _filePath = await _getFilePath();

    try {
      await _recorder.startRecorder(
        toFile: _filePath,
        codec: Codec.aacMP4, // más seguro en Android/iOS
        sampleRate: 16000,       // default
      );

      _isRecording = true;
      notifyListeners();

      // Detener automáticamente después de 30 segundos
      _recordTimer?.cancel();
      _recordTimer = Timer(const Duration(seconds: 30), () async {
        if (_isRecording) await stopRecording();
      });
    } catch (e) {
      debugPrint('Error al iniciar grabación: $e');
    }
  }

  // Detiene grabación
  Future<void> stopRecording() async {
  //  if (!_isRecording) return;

    try {
      await _recorder.stopRecorder();
      _isRecording = false;
      _recordTimer?.cancel();
      notifyListeners();
    } catch (e) {
      debugPrint('Error al detener grabación: $e');
    }
  }

  // Enviar mensaje de audio
  Future<void> sendAudioMessage(String chatId) async {
    if (_filePath == null) return;

    try {
      final file = File(_filePath!);
      if (!file.existsSync()) return;

      final ref = _storage
          .ref()
          .child('audios/${DateTime.now().millisecondsSinceEpoch}.aac');

      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      final message = Message(
        id: '',
        senderId: 'user1', // reemplazar por ID real
        text: '',
        timestamp: DateTime.now(),
        isRead: false,
        audioUrl: url,
      );

      await _chatRepository.sendMessage(chatId, message);

      _filePath = null;
      _downloadUrl = url;
      notifyListeners();
    } catch (e) {
      debugPrint('Error enviando audio: $e');
    }
  }

  // Actualiza estado de lectura de un mensaje
  void updateMessageReadStatus(String chatId, String messageId) {
    _chatRepository.updateMessageReadStatus(chatId, messageId);
  }

  // Verifica permisos de micrófono
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
