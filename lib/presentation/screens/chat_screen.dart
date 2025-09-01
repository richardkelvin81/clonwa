import 'package:flutter/material.dart';
import 'package:myapp/presentation/providers/chat_provider.dart';
import 'package:myapp/presentation/widgets/message_bubble.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(context, listen: false).getMessages(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      key: const Key('chat-screen'),
      appBar: AppBar(
        title: Text(widget.chatId), // Replace with user name
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                return MessageBubble(
                  userId: 'user1',
                  message: message,
                  onDisplayed: () {
                    if (!message.isRead) {
                      chatProvider.updateMessageReadStatus(
                          widget.chatId, message.id);
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
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return IconButton(
                icon: Icon(chatProvider.isRecording ? Icons.stop : Icons.mic),
                onPressed: () {
                  if (chatProvider.isRecording) {
                    chatProvider.sendAudioMessage(widget.chatId);
                  } else {
                    chatProvider.startRecording();
                  }
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                Provider.of<ChatProvider>(context, listen: false)
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
