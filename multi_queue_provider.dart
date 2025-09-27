// lib/providers/multi_queue_provider.dart
import 'dart:math';
import 'package:flutter/foundation.dart';

class QueueEntry {
  final String id;         // internal unique id
  final String userName;   // name shown in UI
  final String token;      // human token string e.g. CAN-001
  int position;            // 1-based position in queue
  String status;           // "waiting", "served", "skipped"

  QueueEntry({
    required this.id,
    required this.userName,
    required this.token,
    required this.position,
    this.status = "waiting",
  });
}

class MultiQueueProvider with ChangeNotifier {
  final Map<String, List<QueueEntry>> _queues = {};
  final Map<String, int> _nextToken = {};

  // local (device) tracked token/service (optional)
  String? myToken;
  String? myServiceId;
  int? myPosition;

  // --- Public API ---

  // get a copy of the queue (read-only list)
  List<QueueEntry> getQueue(String serviceId) => List.unmodifiable(_queues[serviceId] ?? []);

  // join a queue (student). Returns the created QueueEntry.
  Future<QueueEntry> joinQueue(String serviceId, String userName) async {
    _queues.putIfAbsent(serviceId, () => []);
    _nextToken.putIfAbsent(serviceId, () => 1);

    final tokenNumber = _nextToken[serviceId]!;
    final tokenStr = '${serviceId.substring(0, min(3, serviceId.length)).toUpperCase()}-${tokenNumber.toString().padLeft(3, '0')}';
    final id = '${serviceId}_${tokenNumber}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    final position = _queues[serviceId]!.length + 1;

    final entry = QueueEntry(
      id: id,
      userName: userName,
      token: tokenStr,
      position: position,
    );

    _queues[serviceId]!.add(entry);
    _nextToken[serviceId] = tokenNumber + 1;

    // save on device
    myToken = tokenStr;
    myServiceId = serviceId;
    myPosition = position;

    notifyListeners();
    return entry;
  }

  // student leaves/cancels
  void leaveQueue(String serviceId, String token) {
    final queue = _queues[serviceId];
    if (queue == null) return;
    queue.removeWhere((e) => e.token == token);

    if (myServiceId == serviceId && myToken == token) {
      myToken = null;
      myServiceId = null;
      myPosition = null;
    }

    _reassignPositions(serviceId);
    notifyListeners();
  }

  // admin calls next (dequeue first waiting)
  QueueEntry? serveNext(String serviceId) {
    final queue = _queues[serviceId];
    if (queue == null || queue.isEmpty) return null;

    final next = queue.removeAt(0);
    next.status = 'served';

    _reassignPositions(serviceId);
    _updateMyPositionAfterChange(serviceId);
    notifyListeners();
    return next;
  }

  // admin can skip a particular token
  void skipStudent(String serviceId, String token) {
    final queue = _queues[serviceId];
    if (queue == null) return;
    final idx = queue.indexWhere((e) => e.token == token);
    if (idx >= 0) {
      queue[idx].status = 'skipped';
      notifyListeners();
    }
  }

  // reset queue (admin)
  void resetQueue(String serviceId) {
    _queues[serviceId] = [];
    _nextToken[serviceId] = 1;
    if (myServiceId == serviceId) {
      myServiceId = null;
      myToken = null;
      myPosition = null;
    }
    notifyListeners();
  }

  // fetch/refresh (for local-only implementation)
  Future<void> fetchQueueStatus(String serviceId) async {
    _reassignPositions(serviceId);
    _updateMyPositionAfterChange(serviceId);
    notifyListeners();
  }

  // helper to get the position of the local token (if any)
  int? getMyPosition(String serviceId) {
    if (myServiceId == null || myToken == null) return null;
    if (myServiceId != serviceId) return null;
    return myPosition;
  }

  String? getMyToken(String serviceId) {
    if (myServiceId == serviceId) return myToken;
    return null;
  }

  // ---------------- helpers ----------------
  void _reassignPositions(String serviceId) {
    final queue = _queues[serviceId];
    if (queue == null) return;
    for (int i = 0; i < queue.length; i++) {
      queue[i].position = i + 1;
    }
  }

  void _updateMyPositionAfterChange(String serviceId) {
    if (myServiceId != serviceId || myToken == null) {
      myPosition = null;
      return;
    }
    final queue = _queues[serviceId] ?? [];
    final idx = queue.indexWhere((e) => e.token == myToken);
    myPosition = idx >= 0 ? idx + 1 : null;
    if (myPosition == null) {
      // local user might have been served or removed
      myToken = null;
      myServiceId = null;
    }
  }
}
