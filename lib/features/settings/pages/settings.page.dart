import 'dart:developer';

import 'package:clippy/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/app_theme.module.dart';
import '../../../core/providers/user_preferences.provider.dart';
import '../../auth/providers/auth.riverpod.dart';
import '../../auth/state/auth.state.dart';

class SettingsPage extends ConsumerWidget {
  static String route() => "/settings";
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newState = ref.read(authProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.of(context).settings),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text("Language"),
              subtitle: Text(
                  ref.watch(userPreferencesProvider).locale.toLanguageTag()),
              leading: const Icon(Icons.language),
              onTap: () {},
              trailing: DropdownButton<Locale>(
                value: ref.read(userPreferencesProvider).locale,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(userPreferencesProvider.notifier).setLocale(value);
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: const Locale.fromSubtags(languageCode: "en"),
                    child: Text(AppLocalization.of(context).english),
                  ),
                  DropdownMenuItem(
                    value: const Locale.fromSubtags(languageCode: "es"),
                    child: Text(AppLocalization.of(context).spanish),
                  ),
                  DropdownMenuItem(
                    value: const Locale.fromSubtags(languageCode: "bn"),
                    child: Text(AppLocalization.of(context).bengali),
                  ),
                  DropdownMenuItem(
                    value: const Locale.fromSubtags(languageCode: "fr"),
                    child: Text(AppLocalization.of(context).french),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text("Theme"),
              subtitle: Text(ref
                  .watch(userPreferencesProvider.select((v) => v.theme))
                  .label),
              leading: const Icon(Icons.color_lens),
              trailing: DropdownButton<AppTheme>(
                value:
                    ref.watch(userPreferencesProvider.select((v) => v.theme)),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(userPreferencesProvider.notifier).setTheme(value);
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: AppTheme.light,
                    child: Text(AppTheme.light.label),
                  ),
                  DropdownMenuItem(
                    value: AppTheme.dark,
                    child: Text(AppTheme.dark.label),
                  ),
                  DropdownMenuItem(
                    value: AppTheme.system,
                    child: Text(AppTheme.system.label),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(AppLocalization.of(context).logout),
              leading: const Icon(Icons.logout_rounded),
              onTap: () async {
                try {
                  await ref.read(authProvider.notifier).logout();
                  if (newState is AuthStateInitial && context.mounted) {
                    context.pop();
                    return context.replace("/login");
                  }
                } catch (e) {
                  log(e.toString());
                }
              },
            ),
          ],
        )
        // Center(
        //   child: ElevatedButton(
        //     onPressed: () async {
        //       try {
        //         await ref.read(authProvider.notifier).logout();
        //         if (newState is AuthStateInitial && context.mounted) {
        //           context.pop();
        //           return context.replace("/login");
        //         }
        //       } catch (e) {
        //         log(e.toString());
        //       }
        //     },
        //     child: Text(
        //       AppLocalization.of(context).logout,
        //     ),
        //   ),
        // ),

        );
  }
}
