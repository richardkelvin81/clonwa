
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/user.dart';
import '../../logic/entities/pedido.dart';
import '../../sources/repositories/pedidos_repositories.dart';

/// Estado del chat
class PedidosState {
  final List<Pedido> pedidos;
  final List<Usuario> lectores;
  final Pedido? pedido;
 

  const PedidosState({
    this.pedidos = const [],
    this.lectores = const [],
    this.pedido,
   
  });

  PedidosState copyWith({
    List<Pedido>? pedidos,
    List<Usuario>? lectores,
    Pedido? pedido,
  
  }) {
    return PedidosState(
      pedidos: pedidos ?? this.pedidos,
      pedido:pedido?? this.pedido,
      lectores: lectores ?? this.lectores,
     
    );
  }
}

/// Notifier para manejar la lógica del chat
class PedidosNotifier extends StateNotifier<PedidosState> {
  final PedidosRepository _pedidosRepository;




 PedidosNotifier({
    required PedidosRepository pedidosRepository,
 
  })  : _pedidosRepository = pedidosRepository,
      
        super(const PedidosState()) {
          getPedidos();
  
  }




  /// Obtener chats
  void getPedidos() {
    _pedidosRepository.getPedidos().listen((mispedidos) {
      state = state.copyWith(pedidos: mispedidos);
    });
  }
   void getPedido(String idPedido) {
    _pedidosRepository.getPedido(idPedido).listen((mipedido) {
      state = state.copyWith(pedido: mipedido);
    });
  }
    void getLectores(String idPedido) {
    _pedidosRepository.getLectoresPorPedido(idPedido).listen((mislectores) {
      state = state.copyWith(lectores: mislectores);
    });
  }

  Future<void> agregarNuevoPedido() async {
    final pedido = Pedido(
      id: '',
      uid: 'user1', // reemplazar
      descripcion: 'Nuevo pedido de MOTO',
      fecha: DateTime.now(),
      readers: [],
    );
    await _pedidosRepository.addPedido(pedido);
  }
   void actualizarVistaUsuarios(String pedidoId, Usuario usuario) {
    _pedidosRepository.updatePedidoReadStatus(pedidoId, usuario);
  }


}

/// Provider global
final pedidosProvider = StateNotifierProvider<PedidosNotifier, PedidosState>((ref) {
  return PedidosNotifier(pedidosRepository: PedidosRepository());
});
