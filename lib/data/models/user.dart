import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  Usuario({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Usuario(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatar: data['avatar'],
    );
  }
}
