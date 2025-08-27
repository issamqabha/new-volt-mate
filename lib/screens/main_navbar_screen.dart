import 'package:flutter/material.dart';
import 'selection_screen.dart';
import 'car_calculation_screen.dart';
import 'home_appliance_calculation_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainNavBarScreen extends StatefulWidget {
  final String userEmail;
  final String userPassword;

  const MainNavBarScreen({
    super.key,
    required this.userEmail,
    required this.userPassword,
  });

  @override
  State<MainNavBarScreen> createState() => _MainNavBarScreenState();
}

class _MainNavBarScreenState extends State<MainNavBarScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      SelectionScreen(onPageSelected: _onPageSelected),
      const CarCalculationScreen(),
      const HomeApplianceCalculationScreen(),
      const HistoryScreen(),
      ProfileScreen(
        email: widget.userEmail,
        password: widget.userPassword,
      ),
    ];
  }

  void _onPageSelected(int index) {
    setState(() => _currentIndex = index);
  }

  final List<String> _titles = [
    'VOLTMATE',
    'حساب السيارات الكهربائية',
    'حساب الأجهزة الكهربائية',
    'السجل',
    'الملف الشخصي',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onPageSelected,
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(Icons.electric_car), label: 'سيارات'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'أجهزة'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'السجل'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف'),
        ],
      ),
    );
  }
}