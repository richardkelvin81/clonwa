import 'package:go_router/go_router.dart';
import 'package:myapp/presentation/screens/chat_list_screen.dart';
import 'package:myapp/presentation/screens/chat_screen.dart';
import 'package:myapp/presentation/screens/contact_list_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ChatListScreen(),
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (context, state) => ChatScreen(
        chatId: state.pathParameters['chatId']!,
      ),
    ),
    GoRoute(
      path: '/contacts',
      builder: (context, state) => const ContactListScreen(),
    ),
  ],
);
