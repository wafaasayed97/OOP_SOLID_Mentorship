import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('إدارة القهوة الذكية', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[800],
        elevation: 0,
      ),
      body: BlocListener<AhwaManagerCubit, AhwaManagerState>(
        listener: (context, state) {
          if (state is AhwaManagerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'إغلاق',
                  textColor: Colors.white,
                  onPressed: () {
                    // optional: reset error or reload state
                    context.read<AhwaManagerCubit>().resetToLoaded();
                  },
                ),
              ),
            );
          }
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            const DashboardScreen(),
            const AddOrderScreen(),
            ReportsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.brown[800],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'الطلبات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'طلب جديد',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'التقارير',
          ),
        ],
      ),
    );
  }
}
