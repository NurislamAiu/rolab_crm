import 'package:flutter/material.dart';
import 'dashboard_colors.dart';

class DashboardRegistrationsTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const DashboardRegistrationsTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Недавние регистрации', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
                const SizedBox(height: 4),
                const Text('Последние зарегистрированные ученики', style: TextStyle(fontSize: 13, color: textSecondary)),
              ],
            ),
          ),
          const Divider(height: 1, color: borderColor),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5),
              dataTextStyle: const TextStyle(fontSize: 13, color: textPrimary),
              dividerThickness: 1,
              horizontalMargin: 24,
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text('УЧЕНИК')),
                DataColumn(label: Text('ШКОЛА')),
                DataColumn(label: Text('ГРУППА')),
                DataColumn(label: Text('ДАТА')),
              ],
              rows: data.map((e) => DataRow(
                cells: [
                  DataCell(Text(e['name'], style: const TextStyle(fontWeight: FontWeight.w500))),
                  DataCell(Text(e['school'], style: const TextStyle(color: textSecondary))),
                  DataCell(Text(e['group'], style: const TextStyle(color: textSecondary))),
                  DataCell(Text(e['date'], style: const TextStyle(color: textSecondary))),
                ],
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}