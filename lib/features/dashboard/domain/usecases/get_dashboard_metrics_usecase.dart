import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/core/usecases/usecase.dart';
import 'package:rolab_crm/features/dashboard/domain/entities/dashboard_metrics.dart';
import 'package:rolab_crm/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardMetricsUseCase implements UseCase<DashboardMetrics, NoParams> {
  final DashboardRepository repository;

  GetDashboardMetricsUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardMetrics>> call(NoParams params) {
    return repository.getDashboardMetrics();
  }
}
