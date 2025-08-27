import 'package:flutter/material.dart';

class SelectionScreen extends StatelessWidget {
  final Function(int) onPageSelected;

  const SelectionScreen({super.key, required this.onPageSelected});

  void _goToCarCalculation(BuildContext context) {
    onPageSelected(1); // انتقل للصفحة 1 (Car)
  }

  void _goToHomeApplianceCalculation(BuildContext context) {
    onPageSelected(2); // انتقل للصفحة 2 (Home Appliance)
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFE0E7FF)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 50),
          const Text(
            'ماذا تريد أن تحسب؟',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const Icon(Icons.electric_car,
                        color: Colors.deepPurpleAccent, size: 30),
                    title: const Text(
                      'السيارات الكهربائية',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () => _goToCarCalculation(context),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: const Icon(Icons.home,
                        color: Colors.deepPurpleAccent, size: 30),
                    title: const Text(
                      'أجزاء المنزل الكهربائية',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () => _goToHomeApplianceCalculation(context),
                  ),
                ),
              ],
            ),
          ),
          // تم إزالة زر تسجيل الخروج من هنا
        ],
      ),
    );
  }
}