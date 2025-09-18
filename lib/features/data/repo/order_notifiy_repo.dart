import 'package:flutter/foundation.dart';
import 'package:oop_solid/features/data/models/order.dart';
import 'package:oop_solid/core/services/notification_service.dart';

class FlutterOrderNotificationService implements OrderNotificationService {
  @override
  void notifyOrderCompleted(Order order) {
    debugPrint("✅ Order #${order.id} completed for ${order.customerName}");
  }
  
  @override
  void notifyNewOrder(Order order) {
    debugPrint("🔔 New order #${order.id} received from ${order.customerName}");
  }
}