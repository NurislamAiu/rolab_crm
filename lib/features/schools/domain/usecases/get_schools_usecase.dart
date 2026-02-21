import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/school.dart';
import '../repositories/school_repository.dart';

// Юзкейс будет возвращать Stream, чтобы список обновлялся в реальном времени
class GetSchoolsUseCase implements UseCase<Stream<List<School>>, NoParams> {
  final SchoolRepository repository;

  GetSchoolsUseCase(this.repository);

  @override
  Future<Either<Failure, Stream<List<School>>>> call(NoParams params) async {
    // В данном случае usecase просто проксирует вызов к репозиторию,
    // но здесь могла бы быть дополнительная бизнес-логика.
    return repository.getSchools();
  }
}
