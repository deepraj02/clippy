import 'dart:developer';

import 'package:flutter/material.dart';

class LifecycleMonitor extends StatefulWidget {
  final Widget child;
  const LifecycleMonitor({super.key, required this.child});

  @override
  State<LifecycleMonitor> createState() => _LifecycleMonitorState();
}

class _LifecycleMonitorState extends State<LifecycleMonitor>
    with WidgetsBindingObserver {
  AppLifecycleState? lastLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _updateLifecycleState(AppLifecycleState state) {
    setState(() {
      log('AppLifecycleState: $state');
      lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _updateLifecycleState(state);
  }
}
