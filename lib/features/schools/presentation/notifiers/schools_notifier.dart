import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/core/usecases/usecase.dart';
import 'package:rolab_crm/features/auth/domain/entities/app_user.dart';
import '../../../activities/domain/entities/activity.dart';
import '../../../activities/domain/usecases/log_activity_usecase.dart';
import '../../../activities/presentation/providers/activity_providers.dart';
import '../../domain/usecases/add_school_usecase.dart';
import '../../domain/usecases/get_schools_usecase.dart';
import 'schools_state.dart';
import '../providers/school_providers.dart';

final schoolsNotifierProvider =
    StateNotifierProvider<SchoolsNotifier, SchoolsState>((ref) {
  return SchoolsNotifier(
    ref.watch(getSchoolsUseCaseProvider),
    ref.watch(addSchoolUseCaseProvider),
    ref.watch(logActivityUseCaseProvider),
  );
});

class SchoolsNotifier extends StateNotifier<SchoolsState> {
  final GetSchoolsUseCase _getSchoolsUseCase;
  final AddSchoolUseCase _addSchoolUseCase;
  final LogActivityUseCase _logActivityUseCase;

  SchoolsNotifier(
    this._getSchoolsUseCase, 
    this._addSchoolUseCase,
    this._logActivityUseCase,
  ) : super(SchoolsInitial()) {
    getSchools();
  }

  void getSchools() async {
    state = SchoolsLoading();
    final result = await _getSchoolsUseCase(NoParams());
    result.fold(
      (failure) => state = SchoolsError(failure.message ?? "Ошибка получения данных"),
      (schoolsStream) => state = SchoolsStreamLoaded(schoolsStream),
    );
  }

  Future<void> addSchool({
    required String name,
    required String address,
    required AppUser currentUser,
  }) async {
    final params = AddSchoolParams(name: name, address: address, currentUser: currentUser);
    final result = await _addSchoolUseCase(params);

    result.fold(
      (failure) {
        print("Ошибка добавления школы: ${failure.message}");
      },
      (_) {
        // --- ЛОГИРУЕМ АКТИВНОСТЬ: ДОБАВЛЕНИЕ ШКОЛЫ ---
        _logActivityUseCase(ActivityLog(
          id: '',
          type: 'add_school',
          title: 'Новый филиал',
          description: 'Открыта новая школа "$name"',
          userName: currentUser.fullName,
          createdAt: DateTime.now(),
        ));
      },
    );
  }
}
