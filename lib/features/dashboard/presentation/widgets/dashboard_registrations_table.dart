import 'package:flutter/material.dart';
import 'dashboard_colors.dart';

class DashboardRegistrationsTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const DashboardRegistrationsTable({super.key, required this.data});

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

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
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Недавние регистрации', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
                    SizedBox(height: 4),
                    Text('Последние зарегистрированные ученики', style: TextStyle(fontSize: 13, color: textSecondary)),
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
          
          // Table Data
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  // Use a fixed inner width if the container is smaller, otherwise let it span naturally.
                  width: constraints.maxWidth > 800 ? constraints.maxWidth : 800,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Table Header Row
                      Container(
                        color: const Color(0xFF13151F), // Slight contrast for header
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Row(
                          children: const [
                            Expanded(flex: 3, child: Text('УЧЕНИК', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                            Expanded(flex: 3, child: Text('ШКОЛА', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                            Expanded(flex: 2, child: Text('ГРУППА', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                            Expanded(flex: 2, child: Text('ДАТА', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: borderColor),

                      // Table Rows
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
                                    // Student
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: primaryColor.withOpacity(0.15),
                                            child: Text(
                                              _getInitials(e['name']),
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              e['name'],
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // School
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        e['school'],
                                        style: const TextStyle(fontSize: 13, color: textSecondary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Group
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1F2232),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: borderColor),
                                          ),
                                          child: Text(
                                            e['group'],
                                            style: const TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Date
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        e['date'],
                                        style: const TextStyle(fontSize: 13, color: textSecondary),
                                        overflow: TextOverflow.ellipsis,
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
