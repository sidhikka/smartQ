import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/multi_queue_provider.dart';

class MonitorQueuesScreen extends StatelessWidget {
  const MonitorQueuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultiQueueProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Monitor Queues")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: provider.queues.keys.map((area) {
          final queue = provider.queues[area]!;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ExpansionTile(
              title: Text("$area Queue (${queue.length})"),
              children: queue.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("No tokens in this queue."),
                      )
                    ]
                  : queue.map((token) {
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text("${token.name} (${token.regNo})"),
                        subtitle: Text("Token: ${token.token}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () {
                            provider.removeToken(area, token.token);
                          },
                        ),
                      );
                    }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

