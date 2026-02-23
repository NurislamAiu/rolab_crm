import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rolab_crm/core/config/router/routes.dart';
import 'dashboard_colors.dart';

class DashboardQuickActionsSection extends StatelessWidget {
  const DashboardQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Быстрые действия', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
          const SizedBox(height: 4),
          const Text('Часто используемые операции', style: TextStyle(fontSize: 13, color: textSecondary)),
          const SizedBox(height: 24),
          LayoutBuilder(builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 800;
            return GridView.count(
              crossAxisCount: isDesktop ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isDesktop ? 4 : 3.5,
              children: [
                _QuickActionBtn(icon: Icons.business_rounded, title: 'Добавить школу', onTap: () => context.go(AppRoutes.schools)),
                _QuickActionBtn(icon: Icons.group_add_rounded, title: 'Добавить группу', onTap: () {}),
                _QuickActionBtn(icon: Icons.person_add_rounded, title: 'Добавить ученика', onTap: () {}),
                _QuickActionBtn(icon: Icons.payments_rounded, title: 'Отметить платеж', onTap: () {}),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  
  const _QuickActionBtn({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: textSecondary, size: 18),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
          ],
        ),
      ),
    );
  }
}
