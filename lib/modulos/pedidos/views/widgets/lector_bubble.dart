import 'package:flutter/material.dart';
import 'package:myapp/data/models/user.dart';

class LectorBubble extends StatelessWidget {
  final Usuario usuario;
  final int index;
  final double overlap; // cuánto se solapa (ej: 0.5 = 50%)

  const LectorBubble({
    super.key,
    required this.usuario,
    required this.index,
    this.overlap = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 80; // diámetro = 2 * radius
    final double offset = size * (1 - overlap);

    return Positioned(
      right: index * offset,
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(usuario.avatar!),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}
