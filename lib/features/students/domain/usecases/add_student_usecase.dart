import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/core/usecases/usecase.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';
import 'package:rolab_crm/features/students/domain/repositories/student_repository.dart';

class AddStudentUseCase implements UseCase<void, Student> {
  final StudentRepository repository;

  AddStudentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Student params) {
    // В будущем здесь может быть бизнес-логика: проверка возраста, уникальности и т.д.
    return repository.addStudent(params);
  }
}
