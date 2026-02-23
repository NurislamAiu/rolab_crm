import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rolab_crm/features/schools/domain/entities/school.dart';
import '../notifiers/schools_notifier.dart';
import '../notifiers/schools_state.dart';
import '../widgets/add_edit_school_dialog.dart';

import '../../../dashboard/presentation/widgets/dashboard_colors.dart';

class SchoolsDashboardPage extends ConsumerWidget {
  const SchoolsDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schoolsState = ref.watch(schoolsNotifierProvider);

    Widget buildContent(Widget child) {
      return Container(
        color: bgColor,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(32.0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Schools', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)),
                        SizedBox(height: 8),
                        Text('Manage partner schools and locations', style: TextStyle(fontSize: 14, color: textSecondary)),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddEditSchoolDialog(),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add School'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            child,
          ],
        ),
      );
    }

    return switch (schoolsState) {
      SchoolsInitial() || SchoolsLoading() => buildContent(
          const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
        ),
      SchoolsError(message: final msg) => buildContent(
          SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 64, color: redColor),
                    const SizedBox(height: 16),
                    const Text('Error', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary)),
                    const SizedBox(height: 8),
                    Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: textSecondary)),
                  ],
                ),
              ),
            ),
          ),
        ),
      SchoolsStreamLoaded(schoolsStream: final stream) => StreamBuilder<List<School>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
              return buildContent(
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
              );
            }

            if (snapshot.hasError) {
              return buildContent(
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off_rounded, size: 64, color: redColor),
                          const SizedBox(height: 16),
                          const Text('Connection Error', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary)),
                          const SizedBox(height: 8),
                          Text('${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(color: textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            final schools = snapshot.data ?? [];

            return buildContent(
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // KPIs
                      Row(
                        children: [
                          Expanded(
                            child: _KpiCard(
                              icon: Icons.business_rounded,
                              value: schools.length.toString(),
                              label: 'Total Schools',
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Expanded(
                            child: _KpiCard(
                              icon: Icons.people_alt_rounded,
                              value: '1,847', // Mock total students
                              label: 'Total Students',
                            ),
                          ),
                          const SizedBox(width: 24),
                          const Expanded(
                            child: _KpiCard(
                              icon: Icons.location_on_rounded,
                              value: '8', // Mock cities
                              label: 'Cities Covered',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Search Bar
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
                                'Search schools...',
                                style: TextStyle(color: textSecondary, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Table
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
                                  // Prevents "infinite width" errors by forcing a concrete minimum width
                                  minWidth: constraints.maxWidth > 800 ? constraints.maxWidth : 800,
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
                                            Expanded(flex: 3, child: Text('SCHOOL NAME', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                            Expanded(flex: 3, child: Text('LOCATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                            Expanded(flex: 1, child: Text('STUDENTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                            Expanded(flex: 1, child: Text('GROUPS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                            Expanded(flex: 1, child: Text('STATUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                            Expanded(flex: 1, child: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.5))),
                                          ],
                                        ),
                                      ),
                                      const Divider(height: 1, color: borderColor),
                                  
                                      if (schools.isEmpty)
                                        const Padding(
                                          padding: EdgeInsets.all(32.0),
                                          child: Center(
                                            child: Text('No schools found', style: TextStyle(color: textSecondary)),
                                          ),
                                        )
                                      else
                                        // Table Rows
                                        ...schools.map((school) => _SchoolTableRow(school: school)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    };
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _KpiCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SchoolTableRow extends StatelessWidget {
  final School school;

  const _SchoolTableRow({required this.school});

  @override
  Widget build(BuildContext context) {
    final isNameEmpty = school.name.trim().isEmpty;
    final name = isNameEmpty ? 'Unknown School' : school.name;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.go('/schools/${school.id}');
        },
        hoverColor: Colors.white.withOpacity(0.02),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              // School Name
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F2232),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.business_rounded, color: textSecondary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Location
              Expanded(
                flex: 3,
                child: Text(
                  school.address.isNotEmpty ? school.address : 'Not specified',
                  style: const TextStyle(fontSize: 13, color: textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Students (Mock)
              const Expanded(
                flex: 1,
                child: Text(
                  '287',
                  style: TextStyle(fontSize: 13, color: textSecondary),
                ),
              ),
              // Groups (Mock)
              const Expanded(
                flex: 1,
                child: Text(
                  '12',
                  style: TextStyle(fontSize: 13, color: textSecondary),
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
                      color: greenColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: greenColor.withOpacity(0.2)),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: greenColor),
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
                    onPressed: () => context.go('/schools/${school.id}'),
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      alignment: Alignment.centerLeft,
                    ),
                    child: const Text(
                      'View Details',
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
