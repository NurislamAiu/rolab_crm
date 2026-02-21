import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';
import 'package:rolab_crm/features/students/domain/usecases/add_student_usecase.dart';
import 'package:rolab_crm/features/students/domain/usecases/get_students_in_school_usecase.dart';
import 'package:rolab_crm/features/students/presentation/notifiers/students_state.dart';
import 'package:rolab_crm/features/students/presentation/providers/student_providers.dart';

final studentsNotifierProvider = StateNotifierProvider.family<StudentsNotifier, StudentsState, String>((ref, schoolId) {
  return StudentsNotifier(
    getStudentsInSchoolUseCase: ref.watch(getStudentsInSchoolUseCaseProvider),
    addStudentUseCase: ref.watch(addStudentUseCaseProvider), // <-- Добавляем зависимость
    schoolId: schoolId,
  )..getStudents();
});

class StudentsNotifier extends StateNotifier<StudentsState> {
  final GetStudentsInSchoolUseCase _getStudentsInSchoolUseCase;
  final AddStudentUseCase _addStudentUseCase; // <-- Добавляем usecase
  final String schoolId;

  StudentsNotifier({
    required GetStudentsInSchoolUseCase getStudentsInSchoolUseCase,
    required AddStudentUseCase addStudentUseCase, // <-- Добавляем в конструктор
    required this.schoolId,
  })  : _getStudentsInSchoolUseCase = getStudentsInSchoolUseCase,
        _addStudentUseCase = addStudentUseCase, // <-- Инициализируем
        super(StudentsInitial());
        
  Future<void> getStudents() async {
    state = StudentsLoading();
    final result = await _getStudentsInSchoolUseCase(GetStudentsParams(schoolId: schoolId));

    result.fold(
      (failure) => state = StudentsError(message: failure.message ?? "Ошибка"),
      (stream) => state = StudentsStreamLoaded(studentsStream: stream),
    );
  }

  // --- НОВЫЙ МЕТОД ---
  Future<void> addStudent(Student student) async {
    // Здесь не нужно менять state на Loading, так как список обновится через stream
    final result = await _addStudentUseCase(student);
    result.fold(
      (failure) {
        // В реальном приложении можно показать SnackBar с ошибкой
        print('Ошибка добавления студента: ${failure.message}');
      },
      (success) {
        print('Студент успешно добавлен');
      },
    );
  }
}
