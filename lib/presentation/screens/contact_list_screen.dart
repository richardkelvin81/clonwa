import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../providers/users_provider.dart';

class ContactListScreen extends ConsumerWidget {
  const ContactListScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {

     final usuariosProvider = ref.watch(usersProvider);

    return Scaffold(
      key: const Key('contact-list-screen'),
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
         itemCount: usuariosProvider.users.length,
      
        itemBuilder: (context, index) {
           final usuario = usuariosProvider.users[index];
          return ListTile(
            title: Text('Contact ${usuario.name}'),
            onTap: () {
              // Start a new chat
              context.push('/chat/${usuario.name}');

            },
          );
        },
      ),
    );
  }
}
