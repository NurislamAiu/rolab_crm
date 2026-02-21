import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/exceptions.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/features/students/data/datasources/student_firebase_datasource.dart';
import 'package:rolab_crm/features/students/data/models/student_model.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';
import 'package:rolab_crm/features/students/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentFirebaseDataSource dataSource;

  StudentRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, Stream<List<Student>>>> getStudentsInSchool(String schoolId) async {
    try {
      final stream = dataSource.getStudentsInSchool(schoolId);
      return Right(stream);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addStudent(Student student) async {
    try {
      final studentModel = StudentModel(
          id: student.id,
          schoolId: student.schoolId,
          fullName: student.fullName,
          dateOfBirth: student.dateOfBirth,
          parentFullName: student.parentFullName,
          parentPhoneNumber: student.parentPhoneNumber,
          createdAt: student.createdAt,
          groupId: student.groupId
      );
      await dataSource.addStudent(studentModel);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
