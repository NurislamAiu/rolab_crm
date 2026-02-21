import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/core/usecases/usecase.dart';
import 'package:rolab_crm/features/auth/domain/entities/app_user.dart';
import '../../domain/usecases/add_school_usecase.dart';
import '../../domain/usecases/get_schools_usecase.dart';
import 'schools_state.dart';
import '../providers/school_providers.dart';

// Провайдер для Notifier'а
final schoolsNotifierProvider =
    StateNotifierProvider<SchoolsNotifier, SchoolsState>((ref) {
  return SchoolsNotifier(
    ref.watch(getSchoolsUseCaseProvider),
    ref.watch(addSchoolUseCaseProvider),
  );
});

class SchoolsNotifier extends StateNotifier<SchoolsState> {
  final GetSchoolsUseCase _getSchoolsUseCase;
  final AddSchoolUseCase _addSchoolUseCase;

  SchoolsNotifier(this._getSchoolsUseCase, this._addSchoolUseCase) : super(SchoolsInitial()) {
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
    // Здесь мы не меняем состояние на Loading, т.к. список 
    // обновится автоматически благодаря Stream.
    // Но мы можем обработать результат, чтобы показать ошибку, если она будет.
    final params = AddSchoolParams(name: name, address: address, currentUser: currentUser);
    final result = await _addSchoolUseCase(params);

    result.fold(
      (failure) {
        // Здесь можно передать ошибку в UI, например, через отдельный провайдер
        print("Ошибка добавления школы: ${failure.message}");
      },
      (_) {
        // Успех
        print("Школа успешно добавлена");
      },
    );
  }
}
