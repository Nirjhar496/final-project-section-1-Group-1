import 'package:flutter/material.dart';

class SummaryInfo {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryInfo({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}
