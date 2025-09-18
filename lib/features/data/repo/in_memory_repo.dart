import 'package:oop_solid/features/data/models/order.dart';
import 'package:oop_solid/features/domain/repo/order_repo.dart';

class InMemoryOrderRepository implements OrderRepository {
  final List<Order> _orders = [];
  
  @override
  void addOrder(Order order) {
    _orders.add(order);
  }
  
  @override
  List<Order> getPendingOrders() {
    return _orders.where((order) => !order.isCompleted).toList();
  }
  
  @override
  List<Order> getAllOrders() {
    return List.unmodifiable(_orders);
  }
  
  @override
  Order? getOrderById(int id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  void updateOrder(Order updatedOrder) {
    final index = _orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      _orders[index] = updatedOrder;
    }
  }
}
