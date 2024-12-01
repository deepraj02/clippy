import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gen/locale_provider.g.dart';

@riverpod
class LocaleSettings extends _$LocaleSettings {
  @override
  Locale build() {
    return const Locale.fromSubtags(languageCode: "en");
  }
}
