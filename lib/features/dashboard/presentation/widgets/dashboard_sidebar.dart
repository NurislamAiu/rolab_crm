import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rolab_crm/core/config/router/routes.dart';
import 'dashboard_colors.dart';

class DashboardSidebar extends StatelessWidget {
  final String location;

  const DashboardSidebar({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: bgColor,
        border: Border(
          right: BorderSide(color: borderColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo area
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Text('RoboEdu', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1, color: borderColor),
          const SizedBox(height: 24),
          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _SidebarItem(
                  icon: Icons.grid_view_rounded, 
                  title: 'Панель', 
                  isActive: location == AppRoutes.dashboard,
                  onTap: () {
                    context.go(AppRoutes.dashboard);
                    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
                      Navigator.pop(context); // Close Drawer on mobile
                    }
                  },
                ),
                _SidebarItem(
                  icon: Icons.business_rounded, 
                  title: 'Школы', 
                  isActive: location.startsWith(AppRoutes.schools),
                  onTap: () {
                    context.go(AppRoutes.schools);
                    if (Scaffold.maybeOf(context)?.isDrawerOpen == true) {
                      Navigator.pop(context); // Close Drawer on mobile
                    }
                  },
                ),
                const _SidebarItem(icon: Icons.people_alt_rounded, title: 'Группы'),
                const _SidebarItem(icon: Icons.person_rounded, title: 'Ученики'),
                const _SidebarItem(icon: Icons.assignment_turned_in_rounded, title: 'Посещаемость'),
                const _SidebarItem(icon: Icons.credit_card_rounded, title: 'Платежи'),
                const _SidebarItem(icon: Icons.manage_accounts_rounded, title: 'Пользователи'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback? onTap;

  const _SidebarItem({required this.icon, required this.title, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? Colors.white : textSecondary, size: 22),
            const SizedBox(width: 16),
            Text(
              title, 
              style: TextStyle(
                color: isActive ? Colors.white : textSecondary, 
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
