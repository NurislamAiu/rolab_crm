import 'package:equatable/equatable.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';

sealed class StudentsState extends Equatable {
  const StudentsState();
  @override
  List<Object?> get props => [];
}

class StudentsInitial extends StudentsState {}

class StudentsLoading extends StudentsState {}

class StudentsStreamLoaded extends StudentsState {
  final Stream<List<Student>> studentsStream;
  const StudentsStreamLoaded({required this.studentsStream});

  @override
  List<Object?> get props => [studentsStream];
}

class StudentsError extends StudentsState {
  final String message;
  const StudentsError({required this.message});

  @override
  List<Object?> get props => [message];
}
