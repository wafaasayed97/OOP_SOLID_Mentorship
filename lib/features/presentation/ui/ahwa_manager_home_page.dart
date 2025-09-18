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
  late PageController _pageController;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.dashboard_outlined,
      'activeIcon': Icons.dashboard,
      'label': 'الطلبات',
      'color': Colors.brown[600],
    },
    {
      'icon': Icons.add_circle_outline,
      'activeIcon': Icons.add_circle,
      'label': 'طلب جديد',
      'color': Colors.brown[700],
    },
    {
      'icon': Icons.analytics_outlined,
      'activeIcon': Icons.analytics,
      'label': 'التقارير',
      'color': Colors.brown[800],
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isNavigating = false;

  void _onNavBarTap(int index) {
    if (_isNavigating || _selectedIndex == index) return;
    
    _isNavigating = true;
    setState(() => _selectedIndex = index);
    
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ).then((_) {
      _isNavigating = false;
    });
  }

  void _onPageChanged(int index) {
    // Only update if we're not currently navigating via nav bar
    if (!_isNavigating) {
      setState(() => _selectedIndex = index);
    }
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
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'إغلاق',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          }
        },
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(), // Disable swipe to prevent conflicts
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
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
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
            onTap: _onNavBarTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.brown[600],
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
            elevation: 0,
            items: List.generate(_pages.length, (index) {
              final page = _pages[index];
              final isSelected = _selectedIndex == index;
              
              return BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Colors.brown[600]!.withOpacity(0.1) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    isSelected ? page['activeIcon'] : page['icon'],
                    size: isSelected ? 26.sp : 24.sp,
                  ),
                ),
                label: page['label'],
              );
            }),
          ),
        ),
      ),
    );
  }
}