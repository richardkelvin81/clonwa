import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/presentation/providers/chat_provider.dart';


class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misChatsProvider = ref.watch(chatProvider);

    return Scaffold(
      key: const Key('chat-list-screen'),
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).push('/contacts');
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: misChatsProvider.chats.length,
        itemBuilder: (context, index) {
          final chat = misChatsProvider.chats[index];
          return ListTile(
            title: Text(chat.id), // Replace with user name
            subtitle: Text(chat.lastMessage?.text ?? ''),
            onTap: () {
              GoRouter.of(context).push('/chat/${chat.id}');
            },
          );
        },
      ),
    );
  }
}
