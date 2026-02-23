import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_colors.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/notifiers/auth_state_notifier.dart';

class DashboardTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final AppUser user;

  const DashboardTopBar({super.key, required this.user});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Search Bar
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13151F),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.search, color: textSecondary, size: 18),
                        SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'Поиск...',
                            style: TextStyle(color: textSecondary, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Right Actions
          Row(
            children: [
              // Language Switcher (Hide on very small screens)
              if (MediaQuery.of(context).size.width > 600) ...[
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF13151F),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: const [
                      _LangButton(title: 'EN', isActive: false),
                      _LangButton(title: 'RU', isActive: true),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
              
              // Theme Toggle
              const _IconButton(icon: CupertinoIcons.sun_max),
              const SizedBox(width: 12),
              
              // Notifications
              const _IconButton(icon: CupertinoIcons.bell, hasBadge: true),
              const SizedBox(width: 24),
              
              // User Profile
              GestureDetector(
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (ctx) => CupertinoAlertDialog(
                      title: const Text('Выход'),
                      content: const Text('Вы действительно хотите выйти из аккаунта?'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Отмена'),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.pop(ctx);
                            ref.read(authStateNotifierProvider.notifier).logout();
                          },
                          child: const Text('Выйти'),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  children: [
                    if (MediaQuery.of(context).size.width > 400) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            'Администратор',
                            style: TextStyle(color: textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                    ],
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: primaryColor.withOpacity(0.2),
                      child: Text(
                        _getInitials(user.fullName),
                        style: const TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

class _LangButton extends StatelessWidget {
  final String title;
  final bool isActive;

  const _LangButton({required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final bool hasBadge;

  const _IconButton({required this.icon, this.hasBadge = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF13151F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: textSecondary, size: 18),
          if (hasBadge)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
