import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/models/message.dart';

class Chat {
  final String id;
  final List<String> userIds;
  final Message? lastMessage;

  Chat({
    required this.id,
    required this.userIds,
    this.lastMessage,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      userIds: List<String>.from(data['userIds'] ?? []),
      lastMessage: data['lastMessage'] != null
          ? Message.fromFirestore(data['lastMessage'])
          : null,
    );
  }
}
