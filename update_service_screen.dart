// lib/screens/admin/update_service_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/multi_queue_provider.dart';

class UpdateServiceScreen extends StatelessWidget {
  const UpdateServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultiQueueProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Update Service Status")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: provider.queues.keys.map((area) {
          final status = provider.serviceStatus[area]!;

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(area, style: const TextStyle(fontSize: 18)),
              subtitle: Text("Status: ${_statusText(status)}"),
              trailing: DropdownButton<ServiceStatus>(
                value: status,
                items: ServiceStatus.values.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(_statusText(s)),
                  );
                }).toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    provider.updateServiceStatus(area, newStatus);
                  }
                },
              ),
              leading: CircleAvatar(
                backgroundColor: _statusColor(status),
                child: const Icon(Icons.settings, color: Colors.white),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _statusText(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.open:
        return "Open";
      case ServiceStatus.busy:
        return "Busy";
      case ServiceStatus.closed:
        return "Closed";
    }
  }

  Color _statusColor(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.open:
        return Colors.green;
      case ServiceStatus.busy:
        return Colors.orange;
      case ServiceStatus.closed:
        return Colors.red;
    }
  }
}

