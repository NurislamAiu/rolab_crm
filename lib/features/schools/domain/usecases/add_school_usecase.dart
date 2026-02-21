import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../entities/school.dart';
import '../repositories/school_repository.dart';

class AddSchoolUseCase implements UseCase<void, AddSchoolParams> {
  final SchoolRepository repository;

  AddSchoolUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddSchoolParams params) async {
    // ШАГ 1: Проверка прав доступа
    if (params.currentUser.role != UserRole.admin) {
      // Если пользователь не админ, возвращаем ошибку доступа
      return Left(const PermissionFailure());
    }

    // ШАГ 2: Если проверка пройдена, продолжаем выполнение
    final newSchool = School(
      id: '', // ID будет сгенерирован в data-слое
      name: params.name,
      address: params.address,
      createdAt: DateTime.now(),
    );
    return await repository.addSchool(newSchool);
  }
}

// Обновляем параметры, добавляя текущего пользователя
class AddSchoolParams extends Equatable {
  final String name;
  final String address;
  final AppUser currentUser;

  const AddSchoolParams({
    required this.name,
    required this.address,
    required this.currentUser,
  });

  @override
  List<Object?> get props => [name, address, currentUser];
}
