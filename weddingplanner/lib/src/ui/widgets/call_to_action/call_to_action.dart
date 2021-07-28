import 'package:flutter/material.dart';

class CallToAction extends StatelessWidget {
  final String title;
  CallToAction(this.title);
  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child: FittedBox(
        child: Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w100, color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
        color: hexToColor('#000000'),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
