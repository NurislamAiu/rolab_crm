import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../../auth/presentation/notifiers/auth_state_notifier.dart';

import '../widgets/admin_dashboard_view.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);
    
    return switch (authState) {
      Authenticated(user: final user) => AdminDashboardView(user: user),
      _ => const Center(child: CupertinoActivityIndicator(radius: 16)),
    };
  }
}
