import 'package:flutter/material.dart';

class ProfileMenuItem {
  final String title;
  final IconData icon;
  final String category;

  const ProfileMenuItem({
    required this.title,
    required this.icon,
    required this.category,
  });
  Widget build(BuildContext context) {
    return Row(children: [Icon(icon), Text(title), Text(category)]);
  }
}
