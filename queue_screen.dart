import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/multi_queue_provider.dart';
import 'generate_token_screen.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  static const List<String> queues = [
    "Canteen",
    "Admission",
    "Accounts Center"
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultiQueueProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Queues"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: queues.length,
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            final area = queues[index];
            final status = provider.serviceStatus[area]!;

            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                leading: CircleAvatar(
                  backgroundColor: status == ServiceStatus.closed
                      ? Colors.grey
                      : Colors.deepPurple.withOpacity(0.8),
                  child: const Icon(Icons.queue, color: Colors.white),
                ),
                title: Text(
                  area,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: status == ServiceStatus.closed ? Colors.grey : Colors.black87,
                  ),
                ),
                subtitle: status == ServiceStatus.busy
                    ? const Text("⚠️ Busy queue, expect delays", style: TextStyle(color: Colors.orange))
                    : null,
                trailing: Icon(Icons.arrow_forward_ios,
                    color: status == ServiceStatus.closed ? Colors.grey : Colors.grey),
                onTap: status == ServiceStatus.closed
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GenerateTokenScreen(area: area),
                          ),
                        );
                      },
              ),
            );
          },
        ),
      ),
    );
  }
}

