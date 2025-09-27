import 'package:flutter/material.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  static const List<String> queues = [
    "Canteen",
    "Admission",
    "Accounts Center"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Queues"),
        backgroundColor: const Color(0xFF6A11CB),
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
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.queue, color: Colors.blue),
                title: Text(
                  queues[index],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Show a simple SnackBar as placeholder for token generation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Token generated for ${queues[index]}!"),
                      duration: const Duration(seconds: 2),
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
