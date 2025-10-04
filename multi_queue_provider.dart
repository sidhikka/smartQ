// lib/providers/multi_queue_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum ServiceStatus { open, busy, closed }

class TokenEntry {
  final String regNo;
  final String name;
  final String area;
  final String token;
  final String? fcmToken;

  TokenEntry({
    required this.regNo,
    required this.name,
    required this.area,
    required this.token,
    this.fcmToken,
  });
}

class MultiQueueProvider with ChangeNotifier {
  final Map<String, List<TokenEntry>> _queues = {
    "Canteen": [],
    "Admission": [],
    "Accounts Center": [],
  };

  final Map<String, ServiceStatus> serviceStatus = {
    "Canteen": ServiceStatus.open,
    "Admission": ServiceStatus.open,
    "Accounts Center": ServiceStatus.open,
  };

  // ✅ Token history for reports
  final List<TokenEntry> _tokenHistory = [];

  Map<String, List<TokenEntry>> get queues => _queues;
  List<TokenEntry> get tokenHistory => _tokenHistory;

  /// Generate token and add to queue
  String addToken(String area, String regNo, String name, {String? fcmToken}) {
    final tokenNumber = _queues[area]!.length + 1;
    final token = "T$tokenNumber";
    final entry = TokenEntry(
      regNo: regNo,
      name: name,
      area: area,
      token: token,
      fcmToken: fcmToken,
    );

    _queues[area]!.add(entry);

    // ✅ Add to token history
    _tokenHistory.add(entry);

    notifyListeners();
    return token;
  }

  /// Remove a token from a queue
  void removeToken(String area, String token) {
    _queues[area]!.removeWhere((t) => t.token == token);
    notifyListeners();
  }

  /// Update service status
  void updateServiceStatus(String area, ServiceStatus status) {
    serviceStatus[area] = status;
    notifyListeners();
  }

  /// Call next student and send FCM notification
  Future<void> callNextStudent(String area) async {
    if (_queues[area]!.isEmpty) return;

    final nextStudent = _queues[area]!.first;
    removeToken(area, nextStudent.token);

    if (nextStudent.fcmToken != null) {
      await _sendNotification(
        title: "It's your turn!",
        body: "Token ${nextStudent.token} in $area queue",
        fcmToken: nextStudent.fcmToken!,
      );
    }
  }

  /// Send FCM notification
  Future<void> _sendNotification({
    required String title,
    required String body,
    required String fcmToken,
  }) async {
    const serverKey = 'YOUR_FIREBASE_SERVER_KEY'; // Replace with your FCM server key

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode({
        'to': fcmToken,
        'notification': {'title': title, 'body': body},
        'priority': 'high',
      }),
    );
  }

  /// Get total tokens issued today
  int totalTokensIssued() => _tokenHistory.length;
}
