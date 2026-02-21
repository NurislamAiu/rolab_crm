import 'package:riverpod/riverpod.dart';
import 'package:rolab_crm/features/auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/school_firebase_datasource.dart';
import '../../data/repositories/school_repository_impl.dart';
import '../../domain/repositories/school_repository.dart';
import '../../domain/usecases/add_school_usecase.dart';
import '../../domain/usecases/get_schools_usecase.dart';

// 1. Провайдеры слоя данных
final schoolDataSourceProvider = Provider<SchoolFirebaseDataSource>((ref) {
  return SchoolFirebaseDataSourceImpl(
    firestore: ref.watch(firestoreProvider), // Используем firestoreProvider из auth_providers
  );
});

final schoolRepositoryProvider = Provider<SchoolRepository>((ref) {
  return SchoolRepositoryImpl(
    remoteDataSource: ref.watch(schoolDataSourceProvider),
  );
});

// 2. Провайдеры слоя домена (UseCases)
final getSchoolsUseCaseProvider = Provider<GetSchoolsUseCase>((ref) {
  return GetSchoolsUseCase(ref.watch(schoolRepositoryProvider));
});

final addSchoolUseCaseProvider = Provider<AddSchoolUseCase>((ref) {
  return AddSchoolUseCase(ref.watch(schoolRepositoryProvider));
});
