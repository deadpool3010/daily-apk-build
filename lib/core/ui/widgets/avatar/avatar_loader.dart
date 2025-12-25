import 'package:flutter/material.dart';

class AvatarLoader extends StatelessWidget {
  const AvatarLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
