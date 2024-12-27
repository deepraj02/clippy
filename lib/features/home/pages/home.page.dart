import 'package:clippy/features/home/services/clipboard_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/firebase_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  static String route() => "/home";
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ClipboardService _clipboardService = ClipboardService();

  @override
  void initState() {
    super.initState();
    _clipboardService.startMonitoring();
  }

  @override
  void dispose() {
    _clipboardService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(authStateProvider.select(
      (value) => value.valueOrNull?.displayName,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clippy"),
        actions: [
          IconButton(
              onPressed: () => context.push("/settings"),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Welcome, ${name?.split(" ")[0] ?? 'Guest'}"),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _clipboardService.clipboardStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final clipboardHistory = snapshot.data!;
                  return ListView.builder(
                    itemCount: clipboardHistory.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: const Color.fromARGB(255, 181, 226, 203),
                          child: ListTile(
                            title: Text(clipboardHistory[index]),
                            trailing: IconButton(
                                onPressed: () {
                                  
                                  Clipboard.setData(ClipboardData(
                                      text: clipboardHistory[index]));
                                },
                                icon: const Icon(Icons.copy)),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No clipboard history"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
