import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_cubit.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_state.dart';
import 'package:oop_solid/features/presentation/ui/widgets/order_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AhwaManagerCubit, AhwaManagerState>(
      builder: (context, state) {
        if (state is AhwaManagerLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AhwaManagerError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is AhwaManagerLoaded) {
          final pendingOrders =
              state.orders.where((o) => !o.isCompleted).toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الطلبات المعلقة (${pendingOrders.length})',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.brown[800],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: pendingOrders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.coffee,
                                  size: 80, color: Colors.brown[300]),
                              const SizedBox(height: 16),
                               Text(
                                'مافيش طلبات معلقة يا ريس! ☕',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.brown[600]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: pendingOrders.length,
                          itemBuilder: (context, index) {
                            final order = pendingOrders[index];
                            return OrderCard(
                              order: order,
                              onComplete: () => context
                                  .read<AhwaManagerCubit>()
                                  .completeOrder(order.id),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        }

        // Default (initial state)
        return const Center(child: Text("تحميل الطلبات..."));
      },
    );
  }
}
