import 'package:flutter/material.dart';

class NetworkButton extends StatelessWidget {
  String title;
  NetworkButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF397BE9), Color(0xFF99CDFB)],
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
