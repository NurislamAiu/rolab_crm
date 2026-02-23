import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/features/activities/domain/entities/activity.dart';

abstract class ActivityRepository {
  Future<Either<Failure, Stream<List<ActivityLog>>>> getRecentActivities();
  Future<Either<Failure, void>> logActivity(ActivityLog activity);
}
