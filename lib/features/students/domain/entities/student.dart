import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String schoolId;
  final String? groupId; // Может быть не назначен в группу сразу
  final String fullName;
  final DateTime dateOfBirth;
  final String parentFullName;
  final String parentPhoneNumber;
  final String? iin; // Новое поле: ИИН
  final String? className; // Новое поле: Название класса/группы
  final DateTime createdAt;

  const Student({
    required this.id,
    required this.schoolId,
    this.groupId,
    required this.fullName,
    required this.dateOfBirth,
    required this.parentFullName,
    required this.parentPhoneNumber,
    this.iin, // Добавляем в конструктор
    this.className, // Добавляем в конструктор
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        schoolId,
        groupId,
        fullName,
        dateOfBirth,
        parentFullName,
        parentPhoneNumber,
        iin, // Добавляем в props
        className, // Добавляем в props
        createdAt,
      ];

  Student copyWith({
    String? id,
    String? schoolId,
    String? groupId,
    String? fullName,
    DateTime? dateOfBirth,
    String? parentFullName,
    String? parentPhoneNumber,
    String? iin,
    String? className,
    DateTime? createdAt,
  }) {
    return Student(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      groupId: groupId ?? this.groupId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      parentFullName: parentFullName ?? this.parentFullName,
      parentPhoneNumber: parentPhoneNumber ?? this.parentPhoneNumber,
      iin: iin ?? this.iin,
      className: className ?? this.className,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
