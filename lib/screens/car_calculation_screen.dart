import 'package:flutter/material.dart';
import 'history_data.dart';

class CarCalculationScreen extends StatefulWidget {
  const CarCalculationScreen({super.key});

  @override
  State<CarCalculationScreen> createState() => _CarCalculationScreenState();
}

class _CarCalculationScreenState extends State<CarCalculationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isCalculating = false;

  String? selectedCarType;
  final List<String> carTypes = ['Tesla', 'Nissan', 'KIA', 'Other'];

  final TextEditingController batteryCapacityController = TextEditingController();
  final TextEditingController actualMileageController = TextEditingController();
  final TextEditingController kmToCalculateController = TextEditingController();

  double? resultCost;
  final double pricePerKwh = 0.2;

  void calculateCost() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isCalculating = true);
      final double batteryCapacity = double.parse(batteryCapacityController.text);
      final double kmDriven = double.parse(actualMileageController.text);
      final double kmToCalculate = double.parse(kmToCalculateController.text);

      double energyPerKm = batteryCapacity / kmDriven;
      double cost = energyPerKm * pricePerKwh * kmToCalculate;

      // إضافة للسجل
      history.add(HistoryItem(
        type: 'car',
        data: {
          'car_type': selectedCarType ?? 'غير محدد',
          'battery': batteryCapacity,
          'mileage': kmDriven,
          'km_to_calculate': kmToCalculate,
        },
        cost: cost,
      ));

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          resultCost = cost;
          _isCalculating = false;
        });
      });
    }
  }

  @override
  void dispose() {
    batteryCapacityController.dispose();
    actualMileageController.dispose();
    kmToCalculateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.ev_station, size: 90, color: Colors.deepPurple),
            const SizedBox(height: 20),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'نوع السيارة',
                    border: InputBorder.none,
                  ),
                  value: selectedCarType,
                  items: carTypes
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedCarType = val),
                  validator: (val) => val == null ? 'يرجى اختيار نوع السيارة' : null,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: batteryCapacityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'حجم البطارية (كيلو واط)',
                    border: InputBorder.none,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'الرجاء إدخال حجم البطارية';
                    if (double.tryParse(val) == null) return 'يجب إدخال رقم صالح';
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: actualMileageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'الممشى الفعلي (كم)',
                    border: InputBorder.none,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'الرجاء إدخال الممشى الفعلي';
                    if (double.tryParse(val) == null) return 'يجب إدخال رقم صالح';
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: kmToCalculateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'عدد الكيلومترات للحساب',
                    border: InputBorder.none,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'الرجاء إدخال عدد الكيلومترات';
                    if (double.tryParse(val) == null) return 'يجب إدخال رقم صالح';
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            _isCalculating
                ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
                : ElevatedButton(
              onPressed: calculateCost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'احسب التكلفة',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 25),
            if (resultCost != null)
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.deepPurple[50],
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'التكلفة المقدرة: ${resultCost!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}