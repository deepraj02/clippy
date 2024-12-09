// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'app_theme.module.dart';

class UserPreferencesModel {
  final Locale locale;
  final AppTheme theme;
  const UserPreferencesModel({
    required this.locale,
    required this.theme,
  });

  UserPreferencesModel copyWith({
    Locale? locale,
    AppTheme? theme,
  }) {
    return UserPreferencesModel(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
    );
  }
}
