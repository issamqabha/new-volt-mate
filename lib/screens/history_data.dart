import 'package:intl/intl.dart';

class HistoryItem {
  final String type; // 'car' أو 'appliance'
  final Map<String, dynamic> data;
  final DateTime date;
  final double cost;

  HistoryItem({
    required this.type,
    required this.data,
    required this.cost,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  String get formattedDate {
    return DateFormat('yyyy/MM/dd - hh:mm a').format(date);
  }
}

List<HistoryItem> history = [];