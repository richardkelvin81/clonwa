import 'package:flutter/material.dart';

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
        itemCount: 10, // Replace with actual contact list
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Contact $index'),
            onTap: () {
              // Start a new chat
            },
          );
        },
      ),
    );
  }
}
