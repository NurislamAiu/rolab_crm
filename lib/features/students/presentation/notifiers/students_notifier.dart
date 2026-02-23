import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';
import 'package:rolab_crm/features/students/domain/usecases/add_student_usecase.dart';
import 'package:rolab_crm/features/students/domain/usecases/get_students_in_school_usecase.dart';
import 'package:rolab_crm/features/students/presentation/notifiers/students_state.dart';
import 'package:rolab_crm/features/students/presentation/providers/student_providers.dart';
import '../../../activities/domain/entities/activity.dart';
import '../../../activities/domain/usecases/log_activity_usecase.dart';
import '../../../activities/presentation/providers/activity_providers.dart';

final studentsNotifierProvider = StateNotifierProvider.family<StudentsNotifier, StudentsState, String>((ref, schoolId) {
  return StudentsNotifier(
    getStudentsInSchoolUseCase: ref.watch(getStudentsInSchoolUseCaseProvider),
    addStudentUseCase: ref.watch(addStudentUseCaseProvider),
    logActivityUseCase: ref.watch(logActivityUseCaseProvider),
    schoolId: schoolId,
  )..getStudents();
});

class StudentsNotifier extends StateNotifier<StudentsState> {
  final GetStudentsInSchoolUseCase _getStudentsInSchoolUseCase;
  final AddStudentUseCase _addStudentUseCase;
  final LogActivityUseCase _logActivityUseCase;
  final String schoolId;

  StudentsNotifier({
    required GetStudentsInSchoolUseCase getStudentsInSchoolUseCase,
    required AddStudentUseCase addStudentUseCase,
    required LogActivityUseCase logActivityUseCase,
    required this.schoolId,
  })  : _getStudentsInSchoolUseCase = getStudentsInSchoolUseCase,
        _addStudentUseCase = addStudentUseCase,
        _logActivityUseCase = logActivityUseCase,
        super(StudentsInitial());
        
  Future<void> getStudents() async {
    state = StudentsLoading();
    final result = await _getStudentsInSchoolUseCase(GetStudentsParams(schoolId: schoolId));

    result.fold(
      (failure) => state = StudentsError(message: failure.message ?? "Ошибка"),
      (stream) => state = StudentsStreamLoaded(studentsStream: stream),
    );
  }

  Future<void> addStudent({required Student student, required String adminName}) async {
    final result = await _addStudentUseCase(student);
    result.fold(
      (failure) {
        print('Ошибка добавления студента: ${failure.message}');
      },
      (success) {
        // --- ЛОГИРУЕМ АКТИВНОСТЬ: НОВЫЙ СТУДЕНТ ---
        _logActivityUseCase(ActivityLog(
          id: '',
          type: 'add_student',
          title: 'Новый ученик',
          description: 'Добавлен ученик: ${student.fullName}',
          userName: adminName,
          createdAt: DateTime.now(),
        ));
      },
    );
  }
}
