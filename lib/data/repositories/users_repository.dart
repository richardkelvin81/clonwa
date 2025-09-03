

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UsersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Usuario>> getUsers() {
    return _firestore.collection('usuarios').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Usuario.fromFirestore(doc)).toList();
    });
  }

 
  

}
