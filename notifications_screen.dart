// lib/screens/queue/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/multi_queue_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MultiQueueProvider>(context);

    // If the user has a token, show one helpful notification
    final myService = provider.myServiceId;
    final myToken = myService == null ? null : provider.getMyToken(myService);
    final myPos = myService == null ? null : provider.getMyPosition(myService);

    final List<String> messages = [
      if (myToken != null) 'Your token: $myToken (Position: ${myPos ?? "-"})',
      if (myPos != null && myPos > 1) 'Heads up — your turn is approaching.',
      if (myPos == 1) 'You are next — please proceed to the counter.',
      'Tip: Refresh Live Status to get the latest updates.',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  color: Colors.white.withOpacity(0.12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: messages.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.white30),
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: const Icon(Icons.notifications, color: Colors.white),
                        title: Text(messages[i], style: const TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulated push permission granted (placeholder)')));
                  },
                  child: const Text('Enable Notifications (Simulated)'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
