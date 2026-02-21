import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/features/dashboard/domain/entities/dashboard_metrics.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardMetrics>> getDashboardMetrics();
}
