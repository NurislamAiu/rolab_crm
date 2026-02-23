import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/core/usecases/usecase.dart';
import 'package:rolab_crm/features/activities/domain/entities/activity.dart';
import 'package:rolab_crm/features/activities/domain/repositories/activity_repository.dart';

class LogActivityUseCase implements UseCase<void, ActivityLog> {
  final ActivityRepository repository;

  LogActivityUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ActivityLog params) {
    return repository.logActivity(params);
  }
}
