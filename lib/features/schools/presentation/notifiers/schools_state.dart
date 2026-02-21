import 'package:equatable/equatable.dart';
import '../../domain/entities/school.dart';

// Меняем abstract на sealed
sealed class SchoolsState extends Equatable {
  const SchoolsState();
  @override
  List<Object> get props => [];
}

class SchoolsInitial extends SchoolsState {}

class SchoolsLoading extends SchoolsState {}

class SchoolsStreamLoaded extends SchoolsState {
  final Stream<List<School>> schoolsStream;
  const SchoolsStreamLoaded(this.schoolsStream);

  @override
  List<Object> get props => [schoolsStream];
}

class SchoolsError extends SchoolsState {
  final String message;
  const SchoolsError(this.message);

  @override
  List<Object> get props => [message];
}
