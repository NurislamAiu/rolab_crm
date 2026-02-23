import 'package:equatable/equatable.dart';

class DashboardMetrics extends Equatable {
  final int schoolCount;
  final int studentCount;
  // В будущем здесь будут другие метрики: monthlyRevenue, debts и т.д.

  const DashboardMetrics({
    required this.schoolCount,
    required this.studentCount,
  });

  @override
  List<Object?> get props => [schoolCount, studentCount];
}
