
import 'package:equatable/equatable.dart';
import 'package:oop_solid/features/data/models/order.dart';

sealed class AhwaManagerState extends Equatable {
  const AhwaManagerState();

  @override
  List<Object?> get props => [];
}

final class AhwaManagerInitial extends AhwaManagerState {}

final class AhwaManagerLoading extends AhwaManagerState {}

final class AhwaManagerLoaded extends AhwaManagerState {
  final List<Order> orders;
  final int totalOrdersToday;
  final double totalRevenueToday;
  final Map<String, int> topSellingDrinks;

  const AhwaManagerLoaded({
    required this.orders,
    required this.totalOrdersToday,
    required this.totalRevenueToday,
    required this.topSellingDrinks,
  });

  @override
  List<Object?> get props => [
        orders,
        totalOrdersToday,
        totalRevenueToday,
        topSellingDrinks,
      ];
}

final class AhwaManagerError extends AhwaManagerState {
  final String message;
  const AhwaManagerError(this.message);

  @override
  List<Object?> get props => [message];
}
