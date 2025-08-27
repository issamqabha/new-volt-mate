import 'package:flutter/material.dart';
import 'history_data.dart';

class HomeApplianceCalculationScreen extends StatefulWidget {
  const HomeApplianceCalculationScreen({super.key});

  @override
  State<HomeApplianceCalculationScreen> createState() =>
      _HomeApplianceCalculationScreenState();
}

class _HomeApplianceCalculationScreenState
    extends State<HomeApplianceCalculationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isCalculating = false;

  String? selectedAppliance;
  final List<String> appliances = [
    'ثلاجة',
    'غسالة',
    'مكيف هواء',
    'أخرى',
  ];

  final TextEditingController powerConsumptionController = TextEditingController();
  final TextEditingController usageHoursController = TextEditingController();

  double? resultCost;
  final double pricePerKwh = 0.2;

  void calculateCost() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isCalculating = true);
      final double powerConsumption = double.parse(powerConsumptionController.text);
      final double usageHours = double.parse(usageHoursController.text);
      double cost = (powerConsumption * usageHours * pricePerKwh) / 1000;

      history.add(HistoryItem(
        type: 'appliance',
        data: {
          'appliance_type': selectedAppliance ?? 'غير محدد',
          'power': powerConsumption,
          'hours': usageHours,
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
    powerConsumptionController.dispose();
    usageHoursController.dispose();
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
            const Icon(Icons.home, size: 90, color: Colors.deepPurple),
            const SizedBox(height: 20),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'نوع الجهاز',
                    border: InputBorder.none,
                  ),
                  value: selectedAppliance,
                  items: appliances
                      .map((appliance) => DropdownMenuItem(
                    value: appliance,
                    child: Text(appliance),
                  ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedAppliance = val),
                  validator: (val) =>
                  val == null ? 'يرجى اختيار نوع الجهاز' : null,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: powerConsumptionController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'الاستهلاك (واط)',
                    border: InputBorder.none,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'الرجاء إدخال الاستهلاك';
                    if (double.tryParse(val) == null) return 'يجب إدخال رقم صالح';
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: usageHoursController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'عدد الساعات اليومية',
                    border: InputBorder.none,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'الرجاء إدخال عدد الساعات';
                    if (double.tryParse(val) == null) return 'يجب إدخال رقم صالح';
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            _isCalculating
                ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurpleAccent,
              ),
            )
                : ElevatedButton(
              onPressed: calculateCost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'احسب التكلفة',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 25),
            if (resultCost != null)
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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