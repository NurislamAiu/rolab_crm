import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/exceptions.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/features/activities/data/datasources/activity_datasource.dart';
import 'package:rolab_crm/features/activities/data/models/activity_model.dart';
import 'package:rolab_crm/features/activities/domain/entities/activity.dart';
import 'package:rolab_crm/features/activities/domain/repositories/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityDataSource dataSource;

  ActivityRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Stream<List<ActivityLog>>>> getRecentActivities() async {
    try {
      final stream = dataSource.getRecentActivities();
      return Right(stream);
    } on ServerException {
      return const Left(ServerFailure(message: 'Ошибка при загрузке активности'));
    }
  }

  @override
  Future<Either<Failure, void>> logActivity(ActivityLog activity) async {
    try {
      final activityModel = ActivityLogModel(
        id: activity.id,
        type: activity.type,
        title: activity.title,
        description: activity.description,
        userName: activity.userName,
        createdAt: activity.createdAt,
      );
      await dataSource.logActivity(activityModel);
      return const Right(null);
    } on ServerException {
      return const Left(ServerFailure());
    }
  }
}
