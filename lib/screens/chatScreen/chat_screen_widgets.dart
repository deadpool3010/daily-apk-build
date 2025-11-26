import 'package:flutter/material.dart';

Widget chatscreen_header() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 249, 250, 251),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          //blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      children: [
        Image.asset(
          'assets/bandhucare_logo.png',
          fit: BoxFit.contain,
          height: 50,
        ),
      ],
    ),
  );
}
