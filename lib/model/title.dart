import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {

  final String first;
  final String second;

  AppTitle(this.first, this.second);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 30),
          children: [
            TextSpan(
                text: first, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: second),
          ]),
    );
  }
}
