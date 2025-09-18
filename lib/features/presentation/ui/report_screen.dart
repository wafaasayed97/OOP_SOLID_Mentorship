import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_cubit.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_state.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

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
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        }

        if (state is AhwaManagerLoaded) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تقارير اليوم',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.brown[800],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),

                // Daily Statistics Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'إجمالي الطلبات',
                        state.totalOrdersToday.toString(),
                        Icons.receipt_long,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'إجمالي الإيرادات',
                        '${state.totalRevenueToday.toStringAsFixed(1)} ج.م',
                        Icons.monetization_on,
                        Colors.green,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Top Selling Drinks Section
                Text(
                  'أكثر المشروبات مبيعاً',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.brown[700],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: state.topSellingDrinks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bar_chart,
                                  size: 80, color: Colors.brown[300]),
                              const SizedBox(height: 16),
                              Text(
                                'مافيش بيانات للعرض',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.brown[600]),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.topSellingDrinks.length,
                          itemBuilder: (context, index) {
                            final entry =
                                state.topSellingDrinks.entries.elementAt(index);
                            final drinkName = entry.key;
                            final count = entry.value;
                            final percentage = state.totalOrdersToday > 0
                                ? (count / state.totalOrdersToday * 100)
                                : 0.0;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getColorForRank(index),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  drinkName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    '${percentage.toStringAsFixed(1)}% من إجمالي الطلبات'),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.brown[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$count طلب',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown[800],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 16),

                // Refresh Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<AhwaManagerCubit>().refreshReports();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('تحديث التقارير'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Default (Initial State)
        return const Center(
          child: Text("اضغط تحديث لعرض التقارير"),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForRank(int rank) {
    switch (rank) {
      case 0:
        return Colors.amber[600]!; // Gold
      case 1:
        return Colors.grey[400]!; // Silver
      case 2:
        return Colors.brown[400]!; // Bronze
      default:
        return Colors.brown[300]!;
    }
  }
}
