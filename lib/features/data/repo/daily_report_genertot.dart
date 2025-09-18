
import 'package:oop_solid/features/domain/repo/order_repo.dart';
import 'package:oop_solid/features/domain/repo/report_generator_repo.dart';

class DailyReportGenerator implements ReportGenerator {
  final OrderRepository _orderRepository;
  
  DailyReportGenerator(this._orderRepository);
  
  @override
  Map<String, int> getTopSellingDrinks() {
    final today = DateTime.now();
    final todayOrders = _orderRepository.getAllOrders()
        .where((order) => _isSameDay(order.orderTime, today))
        .toList();
    
    Map<String, int> drinkCounts = {};
    for (var order in todayOrders) {
      String drinkName = order.drink.name;
      drinkCounts[drinkName] = (drinkCounts[drinkName] ?? 0) + 1;
    }
    
    var sortedEntries = drinkCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sortedEntries);
  }
  
  @override
  int getTotalOrdersToday() {
    final today = DateTime.now();
    return _orderRepository.getAllOrders()
        .where((order) => _isSameDay(order.orderTime, today))
        .length;
  }
  
  @override
  double getTotalRevenueToday() {
    final today = DateTime.now();
    return _orderRepository.getAllOrders()
        .where((order) => _isSameDay(order.orderTime, today))
        .fold(0.0, (sum, order) => sum + order.getTotalPrice());
  }
  
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}