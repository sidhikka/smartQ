import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/multi_queue_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultiQueueProvider>(context);
    final history = provider.tokenHistory;

    // Group by queue
    final Map<String, List<TokenEntry>> tokensByQueue = {};
    for (var token in history) {
      tokensByQueue[token.area] = tokensByQueue[token.area] ?? [];
      tokensByQueue[token.area]!.add(token);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Daily Reports")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: tokensByQueue.keys.map((area) {
          final tokens = tokensByQueue[area]!;

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ExpansionTile(
              leading: const Icon(Icons.analytics, color: Colors.blue),
              title: Text(
                "$area - Total Tokens: ${tokens.length}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: tokens.map((token) {
                return ListTile(
                  title: Text("${token.name} (${token.regNo})"),
                  subtitle: Text("Token: ${token.token}"),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

