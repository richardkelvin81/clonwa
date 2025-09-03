import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/data/models/user.dart';
import 'package:myapp/modulos/pedidos/views/providers/pedidos_provider.dart';

import '../widgets/lector_bubble.dart';

class VerPedidoScreen extends ConsumerStatefulWidget {
  final String pedidoId;

  const VerPedidoScreen({super.key, required this.pedidoId});

  @override
  ConsumerState<VerPedidoScreen> createState() => _VerPedidoScreenState();
}

class _VerPedidoScreenState extends ConsumerState<VerPedidoScreen> {

late bool cargando=true;
  @override
  void initState() {
    super.initState();
    // Escuchar mensajes del chat al iniciar
    
     Future.microtask(() {
      cargando=true;
       ref.read(pedidosProvider.notifier).getPedido(widget.pedidoId);
      final miuser = Usuario(id: '8lTObECGK0haYv8hLF9k', name: 'juan', email: 'juan.perez@gmail.com',
      avatar: 'https://firebasestorage.googleapis.com/v0/b/taxicorp-bo.appspot.com/o/fotos-conductores%2F1756417063093.jpg?alt=media&token=66aa0bbc-5f4a-40ca-8be4-b35eaf853e02');
   //    final miuser = Usuario(id: '8W49hzD7LMHuvDotE6Ot', name: 'richard', email: 'richard.aparicio@gmail.com',
   // avatar: 'https://avatar.iran.liara.run/public');
     //  final miuser = Usuario(id: '8lTObECGK0haYv8hLF9k', name: 'juan', email: 'juan.perez@gmail.com',
    //  avatar: 'https://firebasestorage.googleapis.com/v0/b/taxicorp-bo.appspot.com/o/fotos-conductores%2F1756417063093.jpg?alt=media&token=66aa0bbc-5f4a-40ca-8be4-b35eaf853e02');
     
       ref.read(pedidosProvider.notifier).actualizarVistaUsuarios(widget.pedidoId, miuser);
        ref.read(pedidosProvider.notifier).getLectores(widget.pedidoId);
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

    print('TOTAL LECTORES ${pedidoState.lectores}');

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
          Text(pedidoState.pedido!.descripcion),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 80, // igual al tamaño del CircleAvatar
                child: Stack(
                  children: [
                    if (pedidoState.lectores.length == 1)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text('Un conductor ha vísto tu pedido!'),
                      )),
                    if (pedidoState.lectores.length > 1)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text('${pedidoState.lectores.length} conductores han vísto tu pedido!'),
                      )),
                    for (int i = 0; i < pedidoState.lectores.length; i++)
                      LectorBubble(
                        usuario: pedidoState.lectores[i],
                        index: i,
                        overlap: 0.5, // 50% de solapamiento
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
