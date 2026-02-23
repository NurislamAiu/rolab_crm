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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Просроченные платежи', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
                    SizedBox(height: 4),
                    Text('Платежи требующие внимания', style: TextStyle(fontSize: 13, color: textSecondary)),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Все'),
                )
              ],
            ),
          ),
          const Divider(height: 1, color: borderColor),
          
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth > 600 ? constraints.maxWidth : 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Row
                      Container(
                        color: const Color(0xFF13151F),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Row(
                          children: const [
                            Expanded(flex: 3, child: Text('УЧЕНИК', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                            Expanded(flex: 2, child: Text('СУММА', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                            Expanded(flex: 2, child: Text('СРОК ОПЛАТЫ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                            Expanded(flex: 2, child: Text('ПРОСРОЧКА', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: borderColor),

                      // Rows
                      ...data.map((e) => Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              hoverColor: Colors.white.withOpacity(0.02),
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: borderColor)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        e['student'],
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        e['amount'],
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textSecondary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        e['dueDate'],
                                        style: const TextStyle(fontSize: 13, color: textSecondary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: redColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: redColor.withOpacity(0.2)),
                                          ),
                                          child: Text(
                                            '${e['daysOverdue']} дней',
                                            style: const TextStyle(color: redColor, fontSize: 11, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
