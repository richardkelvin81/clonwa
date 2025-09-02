import 'package:cloud_firestore/cloud_firestore.dart';


class Pedido {
  final String id;
  final String uid;
  final String descripcion;
  final DateTime fecha;
  final List<Map<String,dynamic>> readers;


  Pedido({
    required this.id,
    required this.uid,
    required this.descripcion,
    required this.fecha,
    required this.readers,

  });

  factory Pedido.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Pedido(
      id: doc.id,
      uid: data['uid'] ?? '',
      descripcion: data['descripcion'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
      readers: List<Map<String,dynamic>>.from(data['readers'] ?? []),
  
    );
  }
}
