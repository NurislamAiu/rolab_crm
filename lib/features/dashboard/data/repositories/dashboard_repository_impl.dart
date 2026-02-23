import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:rolab_crm/core/error/failure.dart';
import 'package:rolab_crm/features/dashboard/domain/entities/dashboard_metrics.dart';
import 'package:rolab_crm/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:rolab_crm/features/schools/domain/repositories/school_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final SchoolRepository schoolRepository;
  final FirebaseFirestore firestore;

  DashboardRepositoryImpl({
    required this.schoolRepository,
    required this.firestore,
  });

  @override
  Future<Either<Failure, DashboardMetrics>> getDashboardMetrics() async {
    try {
      // 1. Сначала получаем школы
      final schoolsEither = await schoolRepository.getSchools();
      
      int schoolCount = 0;
      await schoolsEither.fold(
        (failure) async {
          // Игнорируем или пробрасываем
        },
        (schoolsStream) async {
          final schools = await schoolsStream.first;
          schoolCount = schools.length;
        },
      );

      // 2. Получаем общее количество студентов напрямую из Firestore
      // Так как агрегация Count — это бесплатная/очень дешевая операция в Firestore
      final studentsQuery = await firestore.collection('students').count().get();
      final studentCount = studentsQuery.count ?? 0;

      final metrics = DashboardMetrics(
        schoolCount: schoolCount,
        studentCount: studentCount,
      );

      return Right(metrics);
    } catch (e) {
      return const Left(ServerFailure(message: "Ошибка при получении метрик дашборда"));
    }
  }
}
