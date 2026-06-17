import 'package:flutter/material.dart';

class HomeAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color cardBackgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final String? routeName;

  const HomeAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.cardBackgroundColor,
    required this.titleColor,
    required this.subtitleColor,
    this.routeName,
  });
}
