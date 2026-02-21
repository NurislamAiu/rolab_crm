import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> getCurrentUser();
  Future<Either<Failure, AppUser>> login(String email, String password);
  Future<Either<Failure, void>> logout();
}
