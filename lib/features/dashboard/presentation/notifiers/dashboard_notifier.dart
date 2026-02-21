import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/core/usecases/usecase.dart';
import 'package:rolab_crm/features/dashboard/presentation/notifiers/dashboard_state.dart';
import 'package:rolab_crm/features/dashboard/presentation/providers/dashboard_providers.dart';

import '../../domain/usecases/get_dashboard_metrics_usecase.dart';

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(
    ref.watch(getDashboardMetricsUseCaseProvider),
  )..getMetrics(); // Вызываем метод сразу при создании
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  final GetDashboardMetricsUseCase _getDashboardMetricsUseCase;

  DashboardNotifier(this._getDashboardMetricsUseCase) : super(DashboardInitial());

  Future<void> getMetrics() async {
    state = DashboardLoading();
    final result = await _getDashboardMetricsUseCase(NoParams());

    result.fold(
      (failure) => state = DashboardError(failure.message ?? 'Ошибка'),
      (metrics) => state = DashboardLoaded(metrics),
    );
  }
}
