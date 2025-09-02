import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../data/models/user.dart';
import '../../logic/entities/pedido.dart';

class PedidosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Pedido>> getPedidos() {
    return _firestore.collection('pedidos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Pedido.fromFirestore(doc)).toList();
    });
  }

Stream<Pedido?> getPedido(String pedidoId) {
  return _firestore
      .collection('pedidos')
      .doc(pedidoId)
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) return null;
        return Pedido.fromFirestore(snapshot); // le pasas el snapshot
      });
}

 Future<void> addPedido(Pedido mipedido) async {
    await _firestore
        .collection('pedidos')
        .add({
      'fecha': mipedido.fecha,
      'descripcion': mipedido.descripcion,
      'uid': mipedido.uid,
      'readers': mipedido.readers,

    });
  }

   Future<void> updatePedidoReadStatus(String pedidoId, Usuario usuario) async {
    await _firestore
        .collection('pedidos')
        .doc(pedidoId)
        .collection('readers')
        .doc(usuario.id)
        .set(
          {
            'uid':usuario.id,
            'fecha': DateTime.now(),
            'name':usuario.name,
            'email':usuario.email,
            'avatar':usuario.avatar,

          }
        );
  }
 
  

}
