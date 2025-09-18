import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_cubit.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_state.dart';
import 'package:oop_solid/features/presentation/ui/add_order_screen.dart';
import 'package:oop_solid/features/presentation/ui/dash_board_screen.dart';
import 'package:oop_solid/features/presentation/ui/report_screen.dart';

class AhwaManagerHomePage extends StatefulWidget {
  const AhwaManagerHomePage({super.key});

  @override
  _AhwaManagerHomePageState createState() => _AhwaManagerHomePageState();
}

class _AhwaManagerHomePageState extends State<AhwaManagerHomePage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.dashboard_outlined,
      'activeIcon': Icons.dashboard,
      'label': 'الطلبات',
      'color': Colors.blue,
    },
    {
      'icon': Icons.add_circle_outline,
      'activeIcon': Icons.add_circle,
      'label': 'طلب جديد',
      'color': Colors.green,
    },
    {
      'icon': Icons.analytics_outlined,
      'activeIcon': Icons.analytics,
      'label': 'التقارير',
      'color': Colors.purple,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocListener<AhwaManagerCubit, AhwaManagerState>(
        listener: (context, state) {
          if (state is AhwaManagerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.white, size: 20.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        state.message,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                margin: EdgeInsets.all(16.w),
                action: SnackBarAction(
                  label: 'إغلاق',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<AhwaManagerCubit>().resetToLoaded();
                  },
                ),
              ),
            );
          }
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
          children: const [
            DashboardScreen(),
            AddOrderScreen(),
            ReportsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() => _selectedIndex = index);
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: _pages[_selectedIndex]['color'],
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12.sp,
            ),
            elevation: 0,
            items: _pages.map((page) {
              final index = _pages.indexOf(page);
              final isSelected = _selectedIndex == index;
              
              return BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: isSelected ? page['color'].withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    isSelected ? page['activeIcon'] : page['icon'],
                    size: 24.sp,
                  ),
                ),
                label: page['label'],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}