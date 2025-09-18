import 'package:oop_solid/features/data/models/order.dart';

abstract class OrderRepository {
  void addOrder(Order order);
  List<Order> getPendingOrders();
  List<Order> getAllOrders();
  Order? getOrderById(int id);
  void updateOrder(Order order);
}