import 'package:flutter/material.dart';
import '../../core/design_system/app_colors.dart';
import '../../domain/entities/history_record.dart';

class HistoryDetailPage extends StatelessWidget {
  final HistoryRecord record;

  const HistoryDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        title: const Text('이용 내역 상세'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(record.shop),
            const SizedBox(height: 8),
            Text(_fmt(record.date)),
            const SizedBox(height: 8),
            Text(
              '${record.price}원',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
