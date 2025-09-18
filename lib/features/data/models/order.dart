import 'package:equatable/equatable.dart';
import 'package:oop_solid/features/data/models/drink.dart';

class Order extends Equatable {
  static int _nextId = 1;

  final int _id;
  final String _customerName;
  final Drink _drink;
  final String _specialInstructions;
  final DateTime _orderTime;
  final bool _isCompleted;

  const Order(
    this._id,
    this._customerName,
    this._drink,
    this._specialInstructions,
    this._orderTime,
    this._isCompleted,
  );

  factory Order.create(
    String customerName,
    Drink drink, [
    String specialInstructions = "",
  ]) {
    if (customerName.trim().isEmpty) {
      throw ArgumentError("Customer name cannot be empty");
    }
    return Order(
      _nextId++,
      customerName,
      drink,
      specialInstructions,
      DateTime.now(),
      false,
    );
  }
  factory Order.completed(Order order) {
    return Order(
      order._id,
      order._customerName,
      order._drink,
      order._specialInstructions,
      order._orderTime,
      true,
    );
  }

  int get id => _id;
  String get customerName => _customerName;
  Drink get drink => _drink;
  String get specialInstructions => _specialInstructions;
  DateTime get orderTime => _orderTime;
  bool get isCompleted => _isCompleted;

  double getTotalPrice() => _drink.calculatePrice();

  String getFormattedTime() {
    return "${_orderTime.hour.toString().padLeft(2, '0')}:${_orderTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  List<Object?> get props => [
    _id,
    _customerName,
    _drink,
    _specialInstructions,
    _orderTime,
    _isCompleted,
  ];
}
