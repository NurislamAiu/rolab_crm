import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';

abstract class StudentRepository {
  Future<Either<Failure, Stream<List<Student>>>> getStudentsInSchool(String schoolId);
  Future<Either<Failure, void>> addStudent(Student student);
}
