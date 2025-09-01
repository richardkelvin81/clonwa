import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('contact-list-screen'),
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: 2, // Replace with actual contact list
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Contact user$index'),
            onTap: () {
              // Start a new chat
              context.push('/chat/user$index');

            },
          );
        },
      ),
    );
  }
}
