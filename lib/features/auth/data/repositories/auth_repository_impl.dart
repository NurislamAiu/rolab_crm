import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_firebase_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AppUser>> login(String email, String password) async {
    try {
      final appUser = await remoteDataSource.loginWithEmail(email, password);
      return Right(appUser);
    } on ServerException {
      return Left(ServerFailure(message: "Неверный логин или пароль"));
    }
  }

  @override
  Future<Either<Failure, AppUser>> getCurrentUser() async {
    try {
      final appUser = await remoteDataSource.getCurrentUser();
      return Right(appUser);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
