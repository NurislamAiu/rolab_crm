import 'package:riverpod/riverpod.dart';
import 'package:rolab_crm/features/auth/presentation/providers/auth_providers.dart';
import 'package:rolab_crm/features/students/data/datasources/student_firebase_datasource.dart';
import 'package:rolab_crm/features/students/data/repositories/student_repository_impl.dart';
import 'package:rolab_crm/features/students/domain/repositories/student_repository.dart';
import 'package:rolab_crm/features/students/domain/usecases/add_student_usecase.dart';
import 'package:rolab_crm/features/students/domain/usecases/get_students_in_school_usecase.dart';

// Data Layer
final studentDataSourceProvider = Provider<StudentFirebaseDataSource>((ref) {
  return StudentFirebaseDataSourceImpl(firestore: ref.watch(firestoreProvider));
});

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepositoryImpl(dataSource: ref.watch(studentDataSourceProvider));
});

// Domain Layer
final getStudentsInSchoolUseCaseProvider = Provider<GetStudentsInSchoolUseCase>((ref) {
  return GetStudentsInSchoolUseCase(ref.watch(studentRepositoryProvider));
});

final addStudentUseCaseProvider = Provider<AddStudentUseCase>((ref) {
  return AddStudentUseCase(ref.watch(studentRepositoryProvider));
});
