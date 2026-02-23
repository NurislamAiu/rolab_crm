import 'package:flutter/material.dart';
import 'dashboard_colors.dart';

class DashboardOverduePaymentsTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const DashboardOverduePaymentsTable({super.key, required this.data});

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
                const Text('Просроченные платежи', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
                const SizedBox(height: 4),
                const Text('Платежи требующие внимания', style: TextStyle(fontSize: 13, color: textSecondary)),
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
                DataColumn(label: Text('СУММА')),
                DataColumn(label: Text('СРОК ОПЛАТЫ')),
                DataColumn(label: Text('ПРОСРОЧКА')),
              ],
              rows: data.map((e) => DataRow(
                cells: [
                  DataCell(Text(e['student'], style: const TextStyle(fontWeight: FontWeight.w500))),
                  DataCell(Text(e['amount'], style: const TextStyle(color: textSecondary))),
                  DataCell(Text(e['dueDate'], style: const TextStyle(color: textSecondary))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: redColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: redColor.withOpacity(0.2)),
                      ),
                      child: Text('${e['daysOverdue']} дней', style: const TextStyle(color: redColor, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ),
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