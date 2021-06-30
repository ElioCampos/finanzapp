import 'package:flutter/material.dart';

Widget stylish(String stylish, double size, double stroke) {
    return Stack(
      children: <Widget>[
        Text(
          stylish,
          style: TextStyle(
            fontSize: size,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = stroke
              ..color = Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          stylish,
          style: TextStyle(
            fontSize: size,
            color: Colors.green[300],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }