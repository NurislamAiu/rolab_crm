import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failure.dart';

// Абстрактный класс для всех юзкейсов
// Type - тип возвращаемого значения
// Params - параметры, которые принимает юзкейс
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Класс для юзкейсов, которые не принимают параметров
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
