import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/core/usecases/usecase.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';
import 'package:rolab_crm/features/students/domain/repositories/student_repository.dart';

class GetStudentsInSchoolUseCase implements UseCase<Stream<List<Student>>, GetStudentsParams> {
  final StudentRepository repository;

  GetStudentsInSchoolUseCase(this.repository);

  @override
  Future<Either<Failure, Stream<List<Student>>>> call(GetStudentsParams params) {
    return repository.getStudentsInSchool(params.schoolId);
  }
}

class GetStudentsParams extends Equatable {
  final String schoolId;
  const GetStudentsParams({required this.schoolId});
  @override
  List<Object?> get props => [schoolId];
}
