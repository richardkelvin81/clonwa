import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/models/user.dart';
import 'package:myapp/modulos/pedidos/views/providers/pedidos_provider.dart';

class VerPedidoScreen extends ConsumerStatefulWidget {
  final String pedidoId;

  const VerPedidoScreen({super.key, required this.pedidoId});

  @override
  ConsumerState<VerPedidoScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<VerPedidoScreen> {

late bool cargando=true;
  @override
  void initState() {
    super.initState();
    // Escuchar mensajes del chat al iniciar
    
     Future.microtask(() {
      cargando=true;
       ref.read(pedidosProvider.notifier).getPedido(widget.pedidoId);
      final miuser = Usuario(id: '8W49hzD7LMHuvDotE6Ot', name: 'richard', email: 'richard.aparicio@gmail.com',
      avatar: 'https://avatar.iran.liara.run/public');
     
       ref.read(pedidosProvider.notifier).actualizarVistaUsuarios(widget.pedidoId, miuser);
       Future.delayed(const Duration(seconds: 3),(){
         setState(() {
            cargando=false;
         }); 
       });
       
     });
  }

  @override
  Widget build(BuildContext context) {
    final pedidoState = ref.watch(pedidosProvider);

    return Scaffold(
      key: const Key('ver-pedido-screen'),
      appBar: AppBar(
        title: Text(widget.pedidoId), // Reemplazar con nombre de usuario real
      ),
      body: 
      cargando
      ?const Center(
        child: CircularProgressIndicator(),
      )
      :Column(
        children: [
          Text(pedidoState.pedido!.fecha.toString()),
          const SizedBox(height: 10,),
          Text(pedidoState.pedido!.descripcion)
        ],
      ),
    );
  }


}
