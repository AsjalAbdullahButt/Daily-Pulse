import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/connection_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Kicks off backend health check right after build.
    Future.microtask(() => context.read<ConnectionProvider>().checkConnection());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ConnectionProvider>().state;
    final label = switch (state) {
      ConnectionState.checking => 'Checking connection...',
      ConnectionState.connected => 'Connected to backend ✅',
      ConnectionState.failed => 'Connection failed ❌',
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Pulse')),
      body: Center(child: Text(label, style: const TextStyle(fontSize: 18))),
    );
  }
}
