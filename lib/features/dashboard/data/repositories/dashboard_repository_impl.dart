import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/features/dashboard/domain/entities/dashboard_metrics.dart';
import 'package:rolab_crm/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:rolab_crm/features/schools/domain/repositories/school_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final SchoolRepository schoolRepository;

  DashboardRepositoryImpl({required this.schoolRepository});

  @override
  Future<Either<Failure, DashboardMetrics>> getDashboardMetrics() async {
    // 1. Сначала получаем результат от репозитория школ
    final schoolsEither = await schoolRepository.getSchools();

    // 2. Обрабатываем результат. Fold вернет Future, так как правая часть - async
    return schoolsEither.fold(
      // 2a. Если была ошибка, просто оборачиваем ее в Future и возвращаем
      (failure) async => Left(failure),
      
      // 2b. Если получили стрим, работаем с ним асинхронно
      (schoolsStream) async {
        try {
          // Берем первое (актуальное) значение из стрима
          final schools = await schoolsStream.first;
          final metrics = DashboardMetrics(schoolCount: schools.length);
          // Возвращаем успешный результат
          return Right(metrics);
        } catch (e) {
          // Если произошла ошибка при чтении стрима
          return Left(ServerFailure(message: "Ошибка при чтении данных о школах"));
        }
      },
    );
  }
}
