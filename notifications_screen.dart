// lib/screens/queue/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/multi_queue_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultiQueueProvider>(context);

    // Collect last 5 tokens across all queues
    final allTokens = provider.queues.values.expand((q) => q).toList().reversed.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: allTokens.isEmpty
          ? const Center(child: Text("No notifications yet."))
          : ListView.builder(
              itemCount: allTokens.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final token = allTokens[index];
                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.notifications, color: Colors.blue),
                    title: Text("New Token in ${token.area}"),
                    subtitle: Text("Token: ${token.token} - ${token.name}"),
                  ),
                );
              },
            ),
    );
  }
}

     

