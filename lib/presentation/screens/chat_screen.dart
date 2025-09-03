import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/presentation/providers/chat_provider.dart';
import 'package:myapp/presentation/widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Escuchar mensajes del chat al iniciar
    Future.microtask(() {
      ref.read(chatProvider.notifier).getMessages(widget.chatId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    return Scaffold(
      key: const Key('chat-screen'),
      appBar: AppBar(
        title: Text(widget.chatId), // Reemplazar con nombre de usuario real
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: chatState.messages.length,
              itemBuilder: (context, index) {
                final message = chatState.messages[index];
                return MessageBubble(
                  userId: 'user1',
                  message: message,
                  onDisplayed: () {
                    if (!message.isRead) {
                      ref
                          .read(chatProvider.notifier)
                          .updateMessageReadStatus(widget.chatId, message.id);
                    }
                  },
                );
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    final isRecording = ref.watch(chatProvider).isRecording;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(isRecording ? Icons.stop : Icons.mic),
            onPressed: () {
              final chatNotifier = ref.read(chatProvider.notifier);
              if (isRecording) {
                chatNotifier.sendAudioMessage(widget.chatId);
              } else {
                chatNotifier.startRecording();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                ref
                    .read(chatProvider.notifier)
                    .sendMessage(widget.chatId, _textController.text);
                _textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
