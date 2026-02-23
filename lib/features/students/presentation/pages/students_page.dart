import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/widgets/dashboard_colors.dart';

class StudentsPage extends ConsumerWidget {
  const StudentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // В будущем здесь будет загрузка из Firebase (studentsNotifierProvider)
    // Пока добавим моковые данные, соответствующие дизайну
    final mockStudents = [
      {'name': 'Emma Wilson', 'email': 'emma.w@email.com', 'school': 'Lincoln Elementary', 'group': 'Robotics 101', 'date': 'Jan 15, 2026', 'status': 'Active'},
      {'name': 'James Chen', 'email': 'james.c@email.com', 'school': 'Washington Middle', 'group': 'Advanced AI', 'date': 'Jan 18, 2026', 'status': 'Active'},
      {'name': 'Olivia Martinez', 'email': 'olivia.m@email.com', 'school': 'Roosevelt High', 'group': 'Intro to Coding', 'date': 'Jan 20, 2026', 'status': 'Active'},
      {'name': 'Noah Brown', 'email': 'noah.b@email.com', 'school': 'Kennedy Elementary', 'group': 'Robotics 101', 'date': 'Jan 22, 2026', 'status': 'Active'},
      {'name': 'Sophia Lee', 'email': 'sophia.l@email.com', 'school': 'Jefferson Middle', 'group': 'Intermediate Robotics', 'date': 'Jan 25, 2026', 'status': 'Active'},
      {'name': 'Liam Johnson', 'email': 'liam.j@email.com', 'school': 'Madison High', 'group': 'Advanced AI', 'date': 'Feb 1, 2026', 'status': 'Inactive'},
      {'name': 'Ava Davis', 'email': 'ava.d@email.com', 'school': 'Monroe Elementary', 'group': 'Intro to Coding', 'date': 'Feb 5, 2026', 'status': 'Active'},
      {'name': 'Ethan Garcia', 'email': 'ethan.g@email.com', 'school': 'Adams Middle', 'group': 'Robotics Competition Team', 'date': 'Feb 8, 2026', 'status': 'Active'},
      {'name': 'Isabella Rodriguez', 'email': 'isabella.r@email.com', 'school': 'Lincoln Elementary', 'group': 'Robotics 101', 'date': 'Feb 10, 2026', 'status': 'Active'},
      {'name': 'Mason Taylor', 'email': 'mason.t@email.com', 'school': 'Washington Middle', 'group': 'Advanced AI', 'date': 'Feb 12, 2026', 'status': 'Active'},
    ];

    return Container(
      color: bgColor,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(32.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Header ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Students', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)),
                          SizedBox(height: 8),
                          Text('Manage student enrollments and profiles', style: TextStyle(fontSize: 14, color: textSecondary)),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Student'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- KPIs ---
                  Row(
                    children: const [
                      Expanded(child: _StudentKpiCard(value: '1,847', label: 'Total Students')),
                      SizedBox(width: 24),
                      Expanded(child: _StudentKpiCard(value: '1,782', label: 'Active')),
                      SizedBox(width: 24),
                      Expanded(child: _StudentKpiCard(value: '65', label: 'Inactive')),
                      SizedBox(width: 24),
                      Expanded(child: _StudentKpiCard(value: '142', label: 'New This Month')),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Search Bar ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search_rounded, color: textSecondary, size: 18),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search students by name, email, or school...',
                            style: TextStyle(color: textSecondary, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Table ---
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth > 1000 ? constraints.maxWidth : 1000,
                            ),
                            child: IntrinsicWidth(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Table Header
                                  Container(
                                    color: const Color(0xFF13151F),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    child: Row(
                                      children: const [
                                        Expanded(flex: 3, child: Text('STUDENT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                        Expanded(flex: 3, child: Text('EMAIL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                        Expanded(flex: 2, child: Text('SCHOOL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                        Expanded(flex: 2, child: Text('CURRENT GROUP', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                        Expanded(flex: 2, child: Text('ENROLL DATE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                        Expanded(flex: 1, child: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                        Expanded(flex: 1, child: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1, color: borderColor),

                                  // Table Rows
                                  ...mockStudents.map((s) => _StudentTableRow(student: s)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentKpiCard extends StatelessWidget {
  final String value;
  final String label;

  const _StudentKpiCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: textSecondary),
          ),
        ],
      ),
    );
  }
}

class _StudentTableRow extends StatelessWidget {
  final Map<String, String> student;

  const _StudentTableRow({required this.student});

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
    final isActive = student['status'] == 'Active';

    return Material(
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
              // Student Name
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF1F2232),
                      child: Text(
                        _getInitials(student['name']!),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecondary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        student['name']!,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Email
              Expanded(
                flex: 3,
                child: Text(
                  student['email']!,
                  style: const TextStyle(fontSize: 13, color: textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // School
              Expanded(
                flex: 2,
                child: Text(
                  student['school']!,
                  style: const TextStyle(fontSize: 13, color: textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Group
              Expanded(
                flex: 2,
                child: Text(
                  student['group']!,
                  style: const TextStyle(fontSize: 13, color: textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Enroll Date
              Expanded(
                flex: 2,
                child: Text(
                  student['date']!,
                  style: const TextStyle(fontSize: 13, color: textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Status
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive ? greenColor.withOpacity(0.1) : textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: isActive ? greenColor.withOpacity(0.2) : textSecondary.withOpacity(0.2)),
                    ),
                    child: Text(
                      student['status']!,
                      style: TextStyle(
                        fontSize: 11, 
                        fontWeight: FontWeight.bold, 
                        color: isActive ? greenColor : textSecondary
                      ),
                    ),
                  ),
                ),
              ),
              // Actions
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      alignment: Alignment.centerLeft,
                    ),
                    child: const Text(
                      'View Profile',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
