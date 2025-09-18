import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oop_solid/features/data/models/drink.dart';
import 'package:oop_solid/features/data/models/hibiscus_tea.dart';
import 'package:oop_solid/features/data/models/order.dart';
import 'package:oop_solid/features/data/models/shai_model.dart';
import 'package:oop_solid/features/data/models/turkish_coffee.dart';
import 'package:oop_solid/features/data/repo/in_memory_repo.dart';
import 'package:oop_solid/features/data/repo/order_notifiy_repo.dart';
import 'package:oop_solid/core/services/notification_service.dart';
import 'package:oop_solid/features/domain/repo/order_repo.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_state.dart';


class AhwaManagerCubit extends Cubit<AhwaManagerState> {
  final OrderRepository _orderRepository;
  final OrderNotificationService _notificationService;

  AhwaManagerCubit({
    OrderRepository? orderRepository,
    OrderNotificationService? notificationService,
  })  : _orderRepository = orderRepository ?? InMemoryOrderRepository(),
        _notificationService =
            notificationService ?? FlutterOrderNotificationService(),
        super(AhwaManagerInitial());

  /// Seed demo orders
  void initializeDemoData() {
    addOrder("أحمد", Shai(extraMint: true), "نعناع زيادة يا ريس");
    addOrder("فاطمة", TurkishCoffee(doubleShot: true), "اعملها قوية");
    addOrder("عمر", HibiscusTea(iced: true, extraLemon: true));

    _addDemoCompletedOrders();
  }

  void _addDemoCompletedOrders() {
    final completedOrders = [
      Order.create("سارة", Shai()),
      Order.create("محمد", TurkishCoffee(withSugar: true)),
      Order.create("نور", HibiscusTea(iced: true)),
      Order.create("حسن", Shai(extraMint: true, extraSugar: true)),
    ];

    for (final order in completedOrders) {
      _orderRepository.addOrder(order);
      _orderRepository.updateOrder(Order.completed(order));
    }
  }

  /// Add new order
  void addOrder(String customerName, Drink drink,
      [String specialInstructions = ""]) {
    emit(AhwaManagerLoading());
    try {
      final order = Order.create(customerName, drink, specialInstructions);
      _orderRepository.addOrder(order);
      _notificationService.notifyNewOrder(order);

      _emitLoaded();
    } catch (e) {
      emit(AhwaManagerError("خطأ في إضافة الطلب: ${e.toString()}"));
    }
  }

  /// Complete order
  void completeOrder(int orderId) {
    emit(AhwaManagerLoading());
    try {
      final order = _orderRepository.getOrderById(orderId);
      if (order != null && !order.isCompleted) {
        final completedOrder = Order.completed(order);
        _orderRepository.updateOrder(completedOrder);
        _notificationService.notifyOrderCompleted(completedOrder);
      }
      _emitLoaded();
    } catch (e) {
      emit(AhwaManagerError("خطأ في إنهاء الطلب: ${e.toString()}"));
    }
  }

  /// Refresh reports (used in ReportsScreen)
  void refreshReports() {
    _emitLoaded();
  }

  /// Public method used by UI to clear error and get back to loaded state
  void resetToLoaded() {
    try {
      _emitLoaded();
    } catch (e) {
      emit(AhwaManagerError("خطأ في إعادة الحالة: ${e.toString()}"));
    }
  }

  /// Delete order (stubbed since repo doesn’t support delete)
  void deleteOrder(int orderId) {
    emit(AhwaManagerLoading());
    try {
      // If repo has delete in future, call here
      _emitLoaded();
    } catch (e) {
      emit(AhwaManagerError("خطأ في حذف الطلب: ${e.toString()}"));
    }
  }

  /// Filter orders by drink type (only shows matched orders)
  void filterOrdersByDrink(String drinkName) {
    final filteredOrders = _orderRepository
        .getAllOrders()
        .where((order) => order.drink.name == drinkName)
        .toList();

    final totalOrdersToday = _countTodayOrders(filteredOrders);
    final totalRevenueToday = _calculateRevenue(filteredOrders, onlyToday: true);

    emit(AhwaManagerLoaded(
      orders: filteredOrders,
      totalOrdersToday: totalOrdersToday,
      totalRevenueToday: totalRevenueToday,
      topSellingDrinks: _calculateTopDrinks(filteredOrders, onlyToday: true),
    ));
  }

  /// Reset filter
  void resetToAllOrders() {
    _emitLoaded();
  }

  /// Internal: compute & emit loaded state (based on today's orders for totals/reports)
  void _emitLoaded() {
    final allOrders = _orderRepository.getAllOrders();
    final today = DateTime.now();
    final todayOrders =
        allOrders.where((o) => _isSameDay(o.orderTime, today)).toList();

    final totalOrdersToday = todayOrders.length;
    final totalRevenueToday = _calculateRevenue(todayOrders, onlyToday: false);
    final topSellingDrinks = _calculateTopDrinks(todayOrders, onlyToday: false);

    emit(AhwaManagerLoaded(
      orders: List<Order>.from(allOrders),
      totalOrdersToday: totalOrdersToday,
      totalRevenueToday: totalRevenueToday,
      topSellingDrinks: topSellingDrinks,
    ));
  }

  double _calculateRevenue(List<Order> orders, {bool onlyToday = false}) {
    // orders passed in are already filtered (today or otherwise),
    // so just sum their total prices
    return orders.fold(0.0, (sum, o) => sum + o.getTotalPrice());
  }

  Map<String, int> _calculateTopDrinks(List<Order> orders,
      {bool onlyToday = false}) {
    final Map<String, int> counts = {};
    for (final order in orders) {
      counts[order.drink.name] = (counts[order.drink.name] ?? 0) + 1;
    }

    // Sort by count desc
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted);
  }

  int _countTodayOrders(List<Order> orders) {
    final today = DateTime.now();
    return orders.where((o) => _isSameDay(o.orderTime, today)).length;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
