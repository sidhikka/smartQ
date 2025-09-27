// lib/screens/queue/live_status_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/multi_queue_provider.dart';

const List<Map<String, String>> _services = [
  {'id': 'department', 'title': 'Department (Staff Room)'},
  {'id': 'canteen', 'title': 'Main Canteen'},
  {'id': 'office', 'title': 'Office Room'},
  {'id': 'accounts', 'title': 'Accounts Center'},
];

class LiveStatusScreen extends StatelessWidget {
  const LiveStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultiQueueProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Live Queue Status')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _services.length,
            itemBuilder: (context, i) {
              final s = _services[i];
              final q = provider.getQueue(s['id']!);

              return Card(
                color: Colors.white.withOpacity(0.10),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(s['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('Length: ${q.length}', style: const TextStyle(color: Colors.white70)),
                  children: q.isEmpty
                    ? [const Padding(padding: EdgeInsets.all(12), child: Text('No students in queue', style: TextStyle(color: Colors.white70)))]
                    : q.map((e) => ListTile(
                        title: Text(e.userName, style: const TextStyle(color: Colors.white)),
                        subtitle: Text('Token: ${e.token} • Pos: ${e.position}', style: const TextStyle(color: Colors.white70)),
                      )).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
