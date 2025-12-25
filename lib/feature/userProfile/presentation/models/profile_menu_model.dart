import 'package:flutter/material.dart';

class ProfileMenuModel {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  ProfileMenuModel({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
