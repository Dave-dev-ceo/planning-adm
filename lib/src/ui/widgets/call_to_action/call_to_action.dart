import 'package:flutter/material.dart';

class CallToAction extends StatelessWidget {
  final String title;
  const CallToAction(this.title, {Key? key}) : super(key: key);
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child: FittedBox(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Colors.black,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: hexToColor('#fce5cd'),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
