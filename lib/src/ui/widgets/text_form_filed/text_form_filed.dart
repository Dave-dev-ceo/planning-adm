import 'package:flutter/material.dart';

class TextFormFields extends StatelessWidget {
  final IconData icon;
  final Widget item;
  final double large;
  final double ancho;
  const TextFormFields(
      {Key key,
      @required this.icon,
      @required this.item,
      @required this.large,
      @required this.ancho})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: SizedBox(
        width: large,
        height: ancho,
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            child: ListTile(leading: Icon(icon), title: item)),
      ),
    );
  }
}
