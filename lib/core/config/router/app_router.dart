import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/features/schools/presentation/pages/school_details_page.dart';
import '../../../features/auth/presentation/notifiers/auth_state.dart';
import '../../../features/auth/presentation/notifiers/auth_state_notifier.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../features/dashboard/presentation/pages/main_layout.dart';
import '../../../features/schools/presentation/pages/schools_dashboard_page.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(authStateNotifierProvider, (_, __) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboard,
    refreshListenable: notifier,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authStateNotifierProvider);
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
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainLayout(
            location: state.uri.path, 
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.schools,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SchoolsDashboardPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.schoolDetails, // '/schools/:id'
            pageBuilder: (context, state) {
              final schoolId = state.pathParameters['id']!;
              return NoTransitionPage(
                child: SchoolDetailsPage(schoolId: schoolId),
              );
            },
          ),
        ],
      ),
    ],
  );
});
