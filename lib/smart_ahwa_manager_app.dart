import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oop_solid/features/presentation/logic/cubit/ahwa_manager_cubit.dart';
import 'package:oop_solid/features/presentation/ui/ahwa_manager_home_page.dart';

class SmartAhwaManagerApp extends StatelessWidget {
  const SmartAhwaManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
       designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Ahwa Manager',
        theme: ThemeData(primarySwatch: Colors.brown, fontFamily: 'Arial'),
         home: BlocProvider(
          create: (context) => AhwaManagerCubit()..initializeDemoData(),
          child: AhwaManagerHomePage(),
        ),
      ),
    );
  }
}
