import 'package:equatable/equatable.dart';
import 'package:rolab_crm/features/dashboard/domain/entities/dashboard_metrics.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardMetrics metrics;
  const DashboardLoaded(this.metrics);

  @override
  List<Object?> get props => [metrics];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
