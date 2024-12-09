import 'package:flutter/material.dart';

enum AppTheme {
  light('light', 'Light', ThemeMode.light),
  dark('dark', 'Dark', ThemeMode.dark),
  system('system', 'System', ThemeMode.system),
  ;

  final String value;
  final String label;
  final ThemeMode mode;
  const AppTheme(this.value, this.label, this.mode);
}
