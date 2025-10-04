import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/multi_queue_provider.dart';

class AdminQueueScreen extends StatelessWidget {
  const AdminQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultiQueueProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Monitor Queues")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: provider.queues.keys.map((area) {
          final queue = provider.queues[area]!;
          final status = provider.serviceStatus[area]!;

          Color statusColor;
          String statusText;
          switch (status) {
            case ServiceStatus.open:
              statusText = "Open";
              statusColor = Colors.green;
              break;
            case ServiceStatus.busy:
              statusText = "Busy";
              statusColor = Colors.orange;
              break;
            case ServiceStatus.closed:
              statusText = "Closed";
              statusColor = Colors.red;
              break;
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: statusColor,
                child: Icon(Icons.queue, color: Colors.white),
              ),
              title: Text(
                "$area Queue (${queue.length})",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Status: $statusText", style: TextStyle(color: statusColor)),
              children: queue.isEmpty
                  ? const [ListTile(title: Text("No students in this queue"))]
                  : queue.map((tokenEntry) {
                      return ListTile(
                        leading: const Icon(Icons.person, color: Colors.deepPurple),
                        title: Text("${tokenEntry.name} (${tokenEntry.regNo})"),
                        subtitle: Text("Token: ${tokenEntry.token}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.call, color: Colors.green),
                          onPressed: () {
                            provider.removeToken(area, tokenEntry.token);
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
