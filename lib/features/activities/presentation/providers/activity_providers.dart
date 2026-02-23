import 'package:riverpod/riverpod.dart';
import 'package:rolab_crm/features/activities/data/datasources/activity_datasource.dart';
import 'package:rolab_crm/features/activities/data/repositories/activity_repository_impl.dart';
import 'package:rolab_crm/features/activities/domain/entities/activity.dart';
import 'package:rolab_crm/features/activities/domain/repositories/activity_repository.dart';
import 'package:rolab_crm/features/activities/domain/usecases/log_activity_usecase.dart';
import 'package:rolab_crm/features/auth/presentation/providers/auth_providers.dart';

// DataSource
final activityDataSourceProvider = Provider<ActivityDataSource>((ref) {
  return ActivityDataSourceImpl(firestore: ref.watch(firestoreProvider));
});

// Repository
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepositoryImpl(dataSource: ref.watch(activityDataSourceProvider));
});

// Usecase для логирования событий
final logActivityUseCaseProvider = Provider<LogActivityUseCase>((ref) {
  return LogActivityUseCase(ref.watch(activityRepositoryProvider));
});

// Умный провайдер, который сразу загружает последние 10 действий
final recentActivitiesProvider = StreamProvider<List<ActivityLog>>((ref) async* {
  final repository = ref.watch(activityRepositoryProvider);
  final eitherResult = await repository.getRecentActivities();
  
  yield* eitherResult.fold(
    (failure) => Stream.value([]),
    (stream) => stream,
  );
});
