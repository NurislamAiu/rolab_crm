import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;

  const Failure({this.message});

  @override
  List<Object?> get props => [message];
}

// Общие ошибки
class ServerFailure extends Failure {
  const ServerFailure({super.message});
}

class CacheFailure extends Failure {}

// Ошибка доступа
class PermissionFailure extends Failure {
  const PermissionFailure({super.message = "У вас нет прав для выполнения этого действия"});
}
