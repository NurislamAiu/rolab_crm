import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/features/dashboard/presentation/notifiers/dashboard_notifier.dart';
import 'package:rolab_crm/features/dashboard/presentation/notifiers/dashboard_state.dart';
import '../../../auth/domain/entities/app_user.dart';

import 'dashboard_colors.dart';
import 'dashboard_kpi_card.dart';
import 'dashboard_chart_card.dart';
import 'dashboard_registrations_table.dart';
import 'dashboard_overdue_payments_table.dart';
import 'dashboard_quick_actions.dart';

class AdminDashboardView extends ConsumerWidget {
  final AppUser user;
  const AdminDashboardView({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);

    final revenueData = [85, 92, 88, 98, 105, 127];
    final attendanceData = [92, 88, 85, 90, 87];
    
    final recentRegistrations = [
      {'name': 'Emma Wilson', 'school': 'Lincoln Elementary', 'group': 'Robotics 101', 'date': 'Feb 20, 2026'},
      {'name': 'James Chen', 'school': 'Washington Middle', 'group': 'Advanced AI', 'date': 'Feb 20, 2026'},
      {'name': 'Olivia Martinez', 'school': 'Roosevelt High', 'group': 'Robotics 101', 'date': 'Feb 19, 2026'},
      {'name': 'Noah Brown', 'school': 'Lincoln Elementary', 'group': 'Intro to Coding', 'date': 'Feb 19, 2026'},
      {'name': 'Sophia Lee', 'school': 'Kennedy School', 'group': 'Advanced AI', 'date': 'Feb 18, 2026'},
    ];

    final overduePayments = [
      {'student': 'Liam Johnson', 'amount': '\$250', 'dueDate': 'Feb 10, 2026', 'daysOverdue': 13},
      {'student': 'Ava Davis', 'amount': '\$175', 'dueDate': 'Feb 12, 2026', 'daysOverdue': 11},
      {'student': 'Ethan Garcia', 'amount': '\$300', 'dueDate': 'Feb 15, 2026', 'daysOverdue': 8},
      {'student': 'Isabella Rodriguez', 'amount': '\$225', 'dueDate': 'Feb 17, 2026', 'daysOverdue': 6},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Панель управления', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary)),
                  SizedBox(height: 8),
                  Text('Обзор центра робототехники', style: TextStyle(fontSize: 14, color: textSecondary)),
                ],
              ),
              const SizedBox(height: 32),

              // KPIs
              _buildKpis(isDesktop, dashboardState),
              const SizedBox(height: 24),

              // Charts
              if (isDesktop)
                Row(
                  children: [
                    Expanded(child: DashboardChartCard(title: 'Обзор доходов', subtitle: 'Месячный доход за последние 6 месяцев', isLineChart: true, data: revenueData)),
                    const SizedBox(width: 24),
                    Expanded(child: DashboardChartCard(title: 'Уровень посещаемости', subtitle: 'Процент посещаемости по неделям', isLineChart: false, data: attendanceData)),
                  ],
                )
              else
                Column(
                  children: [
                    DashboardChartCard(title: 'Обзор доходов', subtitle: 'Месячный доход за последние 6 месяцев', isLineChart: true, data: revenueData),
                    const SizedBox(height: 24),
                    DashboardChartCard(title: 'Уровень посещаемости', subtitle: 'Процент посещаемости по неделям', isLineChart: false, data: attendanceData),
                  ],
                ),
              const SizedBox(height: 24),

              // Tables
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: DashboardRegistrationsTable(data: recentRegistrations)),
                    const SizedBox(width: 24),
                    Expanded(child: DashboardOverduePaymentsTable(data: overduePayments)),
                  ],
                )
              else
                Column(
                  children: [
                    DashboardRegistrationsTable(data: recentRegistrations),
                    const SizedBox(height: 24),
                    DashboardOverduePaymentsTable(data: overduePayments),
                  ],
                ),
              const SizedBox(height: 24),

              // Quick Actions
              const DashboardQuickActionsSection(),
              const SizedBox(height: 32),
            ],
          );
        }
      ),
    );
  }

  Widget _buildKpis(bool isDesktop, DashboardState state) {
    String schools = '0';
    String students = '0';
    if (state is DashboardLoaded) {
      schools = state.metrics.schoolCount.toString();
      students = state.metrics.studentCount.toString();
    }

    final cards = [
      DashboardKpiCard(title: 'Всего школ', value: schools, change: '+12%', isUp: true, icon: CupertinoIcons.building_2_fill),
      DashboardKpiCard(title: 'Активные ученики', value: students, change: '+23%', isUp: true, icon: CupertinoIcons.person_2_fill),
      const DashboardKpiCard(title: 'Месячный доход', value: '\$127,450', change: '+18%', isUp: true, icon: CupertinoIcons.money_dollar),
      const DashboardKpiCard(title: 'Неоплаченные', value: '43', change: '-8%', isUp: false, icon: CupertinoIcons.exclamationmark_circle),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: c == cards.last ? 0 : 24), 
            child: c
          )
        )).toList(),
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 16),
              Expanded(child: cards[1]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: cards[2]),
              const SizedBox(width: 16),
              Expanded(child: cards[3]),
            ],
          ),
        ],
      );
    }
  }
}