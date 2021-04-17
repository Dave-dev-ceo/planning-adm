import 'package:flutter/material.dart';

class CallToAction extends StatelessWidget {
  final String title;
  CallToAction(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child: FittedBox(
              child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Colors.white
          ),
        ),
      ),
      decoration: BoxDecoration(color: Colors.pink,
      borderRadius: BorderRadius.circular(5),),
    );
  }
}