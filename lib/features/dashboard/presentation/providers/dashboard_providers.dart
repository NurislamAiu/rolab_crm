import 'package:riverpod/riverpod.dart';
import 'package:rolab_crm/features/auth/presentation/providers/auth_providers.dart';
import 'package:rolab_crm/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:rolab_crm/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:rolab_crm/features/dashboard/domain/usecases/get_dashboard_metrics_usecase.dart';
import 'package:rolab_crm/features/schools/presentation/providers/school_providers.dart';

// 1. Провайдеры слоя данных
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    schoolRepository: ref.watch(schoolRepositoryProvider),
    firestore: ref.watch(firestoreProvider), // Передаем Firestore для агрегации
  );
});

// 2. Провайдеры слоя домена
final getDashboardMetricsUseCaseProvider = Provider<GetDashboardMetricsUseCase>((ref) {
  return GetDashboardMetricsUseCase(ref.watch(dashboardRepositoryProvider));
});
