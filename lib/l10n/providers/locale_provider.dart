import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gen/locale_provider.g.dart';

enum SupportedLanguages {
  english("en"),
  bengali("bn"),
  spanish("es"),
  french("fr");

  final String languageCode;
  const SupportedLanguages(this.languageCode);
}

@riverpod
class LocaleSettings extends _$LocaleSettings {
  @override
  Locale build() {
    String locale = "";
    try {
      locale = Platform.localeName;
    } catch (e) {
      log(e.toString());
      locale = "en";
    }
    String languageCode = locale.split("_").first.toLowerCase();
    if (!["en", "es", "fr", "bn"].contains(languageCode)) {
      languageCode = "en";
    }
    return const Locale.fromSubtags(languageCode: "en");
  }

  void setLanguage(Locale language) {
    state = language;
  }
}
