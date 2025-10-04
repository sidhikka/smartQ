import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/multi_queue_provider.dart';
// Remove firebase_messaging imports until Firebase is set up
// import 'package:firebase_messaging/firebase_messaging.dart';

class GenerateTokenScreen extends StatefulWidget {
  final String area;
  const GenerateTokenScreen({super.key, required this.area});

  @override
  State<GenerateTokenScreen> createState() => _GenerateTokenScreenState();
}

class _GenerateTokenScreenState extends State<GenerateTokenScreen> {
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? generatedToken;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultiQueueProvider>(context, listen: false);
    final status = provider.serviceStatus[widget.area]!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Token - ${widget.area}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Show CLOSED / BUSY messages
            if (status == ServiceStatus.closed)
              _statusCard(
                color: Colors.redAccent,
                icon: Icons.block,
                message: "❌ This service is currently CLOSED.",
              )
            else if (status == ServiceStatus.busy)
              _statusCard(
                color: Colors.orange,
                icon: Icons.warning,
                message: "⚠️ This queue is BUSY. Wait time may be longer.",
              ),
            const SizedBox(height: 12),

            // Register Number input
            TextField(
              controller: regNoController,
              decoration: const InputDecoration(
                labelText: "Register Number",
                filled: true,
                fillColor: Colors.white,
              ),
              enabled: status != ServiceStatus.closed,
            ),
            const SizedBox(height: 16),

            // Name input
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                filled: true,
                fillColor: Colors.white,
              ),
              enabled: status != ServiceStatus.closed,
            ),
            const SizedBox(height: 20),

            // Generate Token button
            ElevatedButton(
              onPressed: status == ServiceStatus.closed
                  ? null
                  : () {
                      if (regNoController.text.isNotEmpty &&
                          nameController.text.isNotEmpty) {
                        // Temporarily use null for FCM token
                        final token = provider.addToken(
                          widget.area,
                          regNoController.text,
                          nameController.text,
                          fcmToken: null, // Replace with FirebaseMessaging token later
                        );

                        setState(() {
                          generatedToken = token;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Token $token generated!")),
                        );
                      }
                    },
              child: const Text("Generate Token"),
            ),
            const SizedBox(height: 20),

            // Show generated token
            if (generatedToken != null)
              Card(
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "✅ Your Token Number: $generatedToken",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper widget for status card
  Widget _statusCard({
    required Color color,
    required IconData icon,
    required String message,
  }) {
    return Card(
      color: color.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
