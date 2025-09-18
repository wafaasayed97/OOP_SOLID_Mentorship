import 'package:oop_solid/features/data/models/order.dart';

abstract class OrderNotificationService {
  void notifyOrderCompleted(Order order);
  void notifyNewOrder(Order order);
}