import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rolab_crm/core/config/router/routes.dart';
import 'package:rolab_crm/features/dashboard/presentation/notifiers/dashboard_notifier.dart';
import 'package:rolab_crm/features/dashboard/presentation/notifiers/dashboard_state.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../../auth/presentation/notifiers/auth_state_notifier.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: Center(
        child: switch (authState) {
          Authenticated(user: final user) =>
            // В зависимости от роли показываем нужный дашборд
            AdminDashboardView(user: user), // Пока у нас только админский
          _ => const CircularProgressIndicator(),
        },
      ),
    );
  }
}

// Отдельный виджет для админского дашборда
class AdminDashboardView extends ConsumerWidget {
  final AppUser user;
  const AdminDashboardView({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);

    return ListView( // Используем ListView для возможности скролла
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Добро пожаловать, ${user.fullName}!', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        
        // Блок 1: KPI-карточки
        Text('Ключевые показатели', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        switch (dashboardState) {
          DashboardLoading() || DashboardInitial() => const Center(child: CircularProgressIndicator()),
          DashboardError(message: final msg) => Center(child: Text(msg)),
          DashboardLoaded(metrics: final metrics) => Wrap( // Wrap для переноса на маленьких экранах
              spacing: 16,
              runSpacing: 16,
              children: [
                KpiCard(title: 'Всего школ', value: metrics.schoolCount.toString()),
                const KpiCard(title: 'Всего студентов', value: '0', isComingSoon: true),
                const KpiCard(title: 'Оплаты в этом месяце', value: '0', isComingSoon: true),
              ],
            ),
        },
        
        const SizedBox(height: 24),

        // Блок 2: Быстрые действия
        Text('Быстрые действия', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.schools),
          child: const Text('Управление школами'),
        ),
      ],
    );
  }
}

// Виджет для одной KPI-карточки
class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isComingSoon;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (isComingSoon)
              Text('скоро', style: Theme.of(context).textTheme.bodySmall)
            else
              Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}
