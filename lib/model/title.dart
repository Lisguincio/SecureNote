import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 30),
          children: [
            TextSpan(
                text: "Secure", style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: "Note"),
          ]),
    );
  }
}
