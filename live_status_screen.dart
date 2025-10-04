// lib/screens/live_status/live_status_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/multi_queue_provider.dart';

class LiveStatusScreen extends StatelessWidget {
  const LiveStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultiQueueProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "📊 Live Queue Status",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: provider.queues.keys.map((area) {
                    final queue = provider.queues[area]!;

                    return Card(
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ExpansionTile(
                        leading: const Icon(Icons.queue, color: Colors.blue),
                        title: Text(
                          "$area Queue (${queue.length})",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: queue.isEmpty
                            ? [
                                const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text(
                                    "No tokens yet.",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              ]
                            : queue.map((tokenEntry) {
                                return ListTile(
                                  leading: const Icon(Icons.person,
                                      color: Colors.deepPurple),
                                  title: Text(
                                    "${tokenEntry.name} (${tokenEntry.regNo})",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle:
                                      Text("Token: ${tokenEntry.token}"),
                                );
                              }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
