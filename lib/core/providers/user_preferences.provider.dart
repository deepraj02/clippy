import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/local_storage/services/local_storage.service.dart';
import '../models/app_theme.module.dart';
import '../models/user_prefs.module.dart';
import 'storage_provider.dart';

part 'user_preferences.provider.g.dart';

@riverpod
class UserPreferences extends _$UserPreferences {
  @override
  UserPreferencesModel build() {
    final locale = _initLocale();
    final theme = _initTheme();
    return UserPreferencesModel(locale: locale, theme: theme);
  }

  Locale _initLocale() {
    String localeName = "";
    String languageCode = "";
    final savedLanguage =
        ref.read(localStorageProvider).getString(LocalStorage.languageKey);
    if (savedLanguage != null) {
      languageCode = savedLanguage;
    } else {
      try {
        localeName = Platform.localeName;
      } catch (e) {
        localeName = "en";
      }
      languageCode = localeName.split('_').first.toLowerCase();
      ref
          .read(localStorageProvider)
          .setString(LocalStorage.languageKey, languageCode);
    }
    if (!['en', 'es', 'fr', 'bn'].contains(languageCode)) {
      languageCode = "en";
    }
    return Locale.fromSubtags(languageCode: languageCode);
  }

  AppTheme _initTheme() {
    final savedTheme =
        ref.read(localStorageProvider).getString(LocalStorage.themeKey);
    if (savedTheme != null) {
      final appTheme = AppTheme.values
          .firstWhereOrNull((theme) => theme.value == savedTheme);
      if (appTheme != null) {
        return appTheme;
      }
    }
    return AppTheme.system;
  }

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
    String languageCode = locale.languageCode.split('_').first.toLowerCase();
    ref
        .read(localStorageProvider)
        .setString(LocalStorage.languageKey, languageCode);
  }

  void setTheme(AppTheme theme) {
    state = state.copyWith(theme: theme);
    ref
        .read(localStorageProvider)
        .setString(LocalStorage.themeKey, theme.value);
  }
}
