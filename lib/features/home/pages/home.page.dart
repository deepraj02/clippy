import 'package:clippy/features/home/services/clipboard_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/firebase_providers.dart';
import '../providers/clipboard.service.riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  static String route() => "/home";
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ClipboardService _clipboardService;

  @override
  void initState() {
    super.initState();
    _clipboardService = ref.read(clipboardProvider);
    _clipboardService.startClipboardMonitoring();
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
    final user = ref.watch(authStateProvider).valueOrNull;
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

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
            child: StreamBuilder<DocumentSnapshot>(
              stream: userDoc.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("No clipboard history"));
                }

                if (!snapshot.data!.exists) {
                  // Initialize document for new users
                  userDoc.set({'copied': []});
                  return const Center(child: Text("No clipboard history"));
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>?;
                if (userData == null) {
                  return const Center(child: Text("No clipboard history"));
                }

                final copiedList = (userData['copied'] as List<dynamic>?) ?? [];
                final reversedList = copiedList.reversed.toList();

                return ListView.builder(
                  itemCount: reversedList.length,
                  itemBuilder: (context, index) {
                    var copiedItem =
                        reversedList[index] as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: const Color.fromARGB(255, 181, 226, 203),
                        child: InkWell(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Delete this item?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        userDoc.update({
                                          'copied': FieldValue.arrayRemove(
                                              [copiedItem])
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Delete"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: copiedItem['copy']));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text("Copied to Clipboard"),
                            ));
                          },
                          child: ListTile(
                            title: Text(
                              copiedItem['copy'],
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
