import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String titulo;
  final IconData icono;

  const TabItem({required this.titulo, required this.icono, Key? key})
      : super(key: key);

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Icon(icono, size: 18),
      child: Text(
        titulo,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
