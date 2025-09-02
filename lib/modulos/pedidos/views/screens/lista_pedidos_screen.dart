
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/modulos/pedidos/views/providers/pedidos_provider.dart';

class ListaPedidosScreen extends ConsumerWidget {
  const ListaPedidosScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {

     final misPedidosProvider = ref.watch(pedidosProvider);

    return Scaffold(
      key: const Key('lista-pedidos-screen'),
      appBar: AppBar(
        title: const Text('Pedidos'),
         actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
             ref.read(pedidosProvider.notifier).agregarNuevoPedido();
            },
          )
        ],
      ),
     
      body: ListView.builder(
         itemCount: misPedidosProvider.pedidos.length,
      
        itemBuilder: (context, index) {
           final pedido = misPedidosProvider.pedidos[index];
          return ListTile(
            title: Text('Fecha ${pedido.fecha}'),
            subtitle: Text(pedido.descripcion),
            onTap: () {
              // Start a new chat
              context.push('/ver-pedido/${pedido.id}');

            },
          );
        },
      ),
    );
  }
}
