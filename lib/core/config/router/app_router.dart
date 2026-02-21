import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/features/schools/presentation/pages/school_details_page.dart';
import '../../../features/auth/presentation/notifiers/auth_state.dart';
import '../../../features/auth/presentation/notifiers/auth_state_notifier.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/schools/presentation/pages/schools_dashboard_page.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final bool isLoggingIn = state.matchedLocation == AppRoutes.login;

      if (authState is AuthInitial || authState is AuthLoading) return null;
      if (authState is Authenticated) {
        if (isLoggingIn) return AppRoutes.dashboard;
      } else {
        if (!isLoggingIn) return AppRoutes.login;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.schools,
        builder: (context, state) => const SchoolsDashboardPage(),
      ),
      // --- ДОБАВЛЯЕМ НОВЫЙ МАРШРУТ ---
      GoRoute(
        path: AppRoutes.schoolDetails, // '/schools/:id'
        builder: (context, state) {
          // Извлекаем id из параметров маршрута
          final schoolId = state.pathParameters['id']!;
          return SchoolDetailsPage(schoolId: schoolId);
        },
      ),
    ],
  );
});
