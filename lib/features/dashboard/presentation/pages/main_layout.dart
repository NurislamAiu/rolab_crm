import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../../auth/presentation/notifiers/auth_state_notifier.dart';

import '../widgets/dashboard_colors.dart';
import '../widgets/dashboard_sidebar.dart';
import '../widgets/dashboard_topbar.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  final String location;

  const MainLayout({super.key, required this.child, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: bgColor,
      // Drawer is built conditionally to ensure the Sidebar widget isn't duplicated
      drawer: !isDesktop 
          ? Drawer(
              backgroundColor: bgColor,
              surfaceTintColor: Colors.transparent,
              child: DashboardSidebar(location: location),
            )
          : null,
      appBar: !isDesktop 
          ? AppBar(
              backgroundColor: bgColor,
              surfaceTintColor: Colors.transparent,
              title: const Text('RoboEdu', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              iconTheme: const IconThemeData(color: Colors.white),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(color: borderColor, height: 1),
              ),
            )
          : null,
      body: switch (authState) {
        Authenticated(user: final user) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show sidebar inline if on Desktop
              if (isDesktop) DashboardSidebar(location: location),
              Expanded(
                child: Column(
                  children: [
                    DashboardTopBar(user: user),
                    // Use a unique Key or an explicit wrapper so GoRouter's Navigator Key doesn't conflict
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          ),
        _ => const Center(child: CupertinoActivityIndicator(radius: 16)),
      },
    );
  }
}
