import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/school.dart';
import '../../domain/repositories/school_repository.dart';
import '../datasources/school_firebase_datasource.dart';
import '../models/school_model.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  final SchoolFirebaseDataSource remoteDataSource;

  SchoolRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Stream<List<School>>>> getSchools() async {
    try {
      final stream = remoteDataSource.getSchools();
      // Оборачиваем успешный стрим в Right
      return Right(stream);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addSchool(School school) async {
    try {
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
