import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/features/schools/domain/entities/school.dart';

abstract class SchoolRepository {
  // Изменяем на Future<Either<Failure, Stream<List<School>>>>
  Future<Either<Failure, Stream<List<School>>>> getSchools();
  Future<Either<Failure, void>> addSchool(School school);
  Future<Either<Failure, void>> updateSchool(School school);
}
