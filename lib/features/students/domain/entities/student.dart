import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String schoolId;
  final String? groupId; // Может быть не назначен в группу сразу
  final String fullName;
  final DateTime dateOfBirth;
  final String parentFullName;
  final String parentPhoneNumber;
  final DateTime createdAt;

  const Student({
    required this.id,
    required this.schoolId,
    this.groupId,
    required this.fullName,
    required this.dateOfBirth,
    required this.parentFullName,
    required this.parentPhoneNumber,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, schoolId, groupId, fullName, dateOfBirth, parentFullName, parentPhoneNumber, createdAt];
}
