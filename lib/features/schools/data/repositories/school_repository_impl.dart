import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/school.dart';
import '../../domain/repositories/school_repository.dart';
import '../datasources/school_firebase_datasource.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolFirebaseDataSource remoteDataSource;

  SchoolRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<Failure, List<School>>> getSchools() {
    return remoteDataSource.getSchools().map((schools) {
      // Здесь SchoolModel автоматически является School (из-за extends),
      // поэтому явный маппинг не нужен. Возвращаем успешный результат.
      return Right<Failure, List<School>>(schools);
    }).handleError((error) {
      // Возвращаем ошибку в виде Failure
      return Left<Failure, List<School>>(ServerFailure());
    });
  }

  @override
  Future<Either<Failure, void>> addSchool(School school) async {
    try {
      // Мы не можем напрямую передать School, т.к. там нет toFirestore.
      // Поэтому нужно создать SchoolModel.
      final schoolModel = SchoolModel(
        id: school.id,
        name: school.name,
        address: school.address,
        createdAt: school.createdAt,
      );
      final result = await remoteDataSource.addSchool(schoolModel);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateSchool(School school) async {
    try {
      final schoolModel = SchoolModel(
        id: school.id,
        name: school.name,
        address: school.address,
        createdAt: school.createdAt,
      );
      final result = await remoteDataSource.updateSchool(schoolModel);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
