import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_cubit.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_state.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<AhwaManagerCubit, AhwaManagerState>(
        builder: (context, state) {
          if (state is AhwaManagerLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'جاري تحميل التقارير...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.brown[600],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is AhwaManagerError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80.sp,
                    color: Colors.red[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AhwaManagerCubit>().refreshReports();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is AhwaManagerLoaded) {
            return Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.brown[800]!, Colors.brown[600]!],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'تقارير اليوم',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'تابع أداء المقهى والمبيعات',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Statistics Cards
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
                            SizedBox(width: 12.w),
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

                        SizedBox(height: 20.h),

                        // Average Order Value Card
                        _buildSectionCard(
                          title: 'معلومات إضافية',
                          icon: Icons.analytics,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildInfoItem(
                                'متوسط قيمة الطلب',
                                state.totalOrdersToday > 0
                                    ? '${(state.totalRevenueToday / state.totalOrdersToday).toStringAsFixed(1)} ج.م'
                                    : '0 ج.م',
                                Icons.trending_up,
                                Colors.purple,
                              ),
                              Container(
                                width: 1,
                                height: 60.h,
                                color: Colors.grey[300],
                              ),
                              _buildInfoItem(
                                'أعلى مبيعات',
                                state.topSellingDrinks.isNotEmpty
                                    ? state.topSellingDrinks.entries.first.key
                                    : 'لا يوجد',
                                Icons.star,
                                Colors.amber,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Top Selling Drinks Section
                        _buildSectionCard(
                          title: 'أكثر المشروبات مبيعاً',
                          icon: Icons.local_cafe,
                          child: state.topSellingDrinks.isEmpty
                              ? _buildEmptyState()
                              : Column(
                                  children: state.topSellingDrinks.entries
                                      .take(5) // Show top 5
                                      .map((entry) {
                                    final index = state.topSellingDrinks.keys
                                        .toList()
                                        .indexOf(entry.key);
                                    return _buildDrinkRankItem(
                                      index,
                                      entry.key,
                                      entry.value,
                                      state.totalOrdersToday,
                                    );
                                  }).toList(),
                                ),
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),

                // Bottom Refresh Button
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.brown[700]!, Colors.brown[800]!],
                      ),
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<AhwaManagerCubit>().refreshReports();
                      },
                      icon: Icon(Icons.refresh, color: Colors.white, size: 24.sp),
                      label: Text(
                        'تحديث التقارير',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Default (Initial State)
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 80.sp,
                  color: Colors.brown[300],
                ),
                SizedBox(height: 16.h),
                Text(
                  'اضغط تحديث لعرض التقارير',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.brown[600],
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AhwaManagerCubit>().refreshReports();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('تحديث التقارير'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.brown[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.brown[600], size: 24.sp),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.8), color],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32.sp),
            SizedBox(height: 12.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDrinkRankItem(int index, String drinkName, int count, int totalOrders) {
    final percentage = totalOrders > 0 ? (count / totalOrders * 100) : 0.0;
    final rankColor = _getColorForRank(index);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: rankColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: rankColor.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),

            // Drink info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drinkName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: percentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: rankColor,
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Count badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '$count طلب',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(
          Icons.bar_chart_outlined,
          size: 60.sp,
          color: Colors.brown[300],
        ),
        SizedBox(height: 16.h),
        Text(
          'مافيش بيانات للعرض',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.brown[600],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'ابدأ بإضافة طلبات لرؤية الإحصائيات',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[500],
          ),
        ),
      ],
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