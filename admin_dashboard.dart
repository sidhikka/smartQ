// lib/screens/admin/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'admin_queue_screen.dart';
import 'update_service_screen.dart';
import 'reports_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                const Text(
                  "👨‍💼 Admin Dashboard",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // Glassmorphism card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Monitor Queues
                      ElevatedButton.icon(
                        icon: const Icon(Icons.queue, size: 26),
                        label: const Text("Monitor Queues",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        style: _buttonStyle(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AdminQueueScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Update Service Status
                      ElevatedButton.icon(
                        icon: const Icon(Icons.update, size: 26),
                        label: const Text("Update Service Status",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        style: _buttonStyle(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const UpdateServiceScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // View Reports
                      ElevatedButton.icon(
                        icon: const Icon(Icons.analytics, size: 26),
                        label: const Text("View Reports",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        style: _buttonStyle(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ReportsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable button style
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(56),
      backgroundColor: Colors.white,
      foregroundColor: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
    );
  }
}
