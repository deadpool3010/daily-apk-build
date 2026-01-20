import 'package:flutter/material.dart';

class ProfileMenuModel {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  ProfileMenuModel({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}
