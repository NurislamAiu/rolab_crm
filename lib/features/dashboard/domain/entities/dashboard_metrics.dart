import 'package:equatable/equatable.dart';

class DashboardMetrics extends Equatable {
  final int schoolCount;
  // В будущем здесь будут другие метрики: studentCount, monthlyRevenue и т.д.

  const DashboardMetrics({
    required this.schoolCount,
  });

  @override
  List<Object?> get props => [schoolCount];
}
