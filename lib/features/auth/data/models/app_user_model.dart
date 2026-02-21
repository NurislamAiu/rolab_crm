import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.uid,
    required super.email,
    required super.fullName,
    required super.role,
    required super.assignedSchoolIds,
    required super.assignedGroupIds,
  });

  // Фабричный конструктор для создания из документа Firestore
  factory AppUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      role: _roleFromString(data['role']),
      assignedSchoolIds: List<String>.from(data['assignedSchoolIds'] ?? []),
      assignedGroupIds: List<String>.from(data['assignedGroupIds'] ?? []),
    );
  }

  // Метод для преобразования в Map для Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'role': role.toShortString(),
      'assignedSchoolIds': assignedSchoolIds,
      'assignedGroupIds': assignedGroupIds,
    };
  }

  // Вспомогательный метод для конвертации строки в enum
  static UserRole _roleFromString(String? roleString) {
    if (roleString == 'admin') return UserRole.admin;
    if (roleString == 'manager') return UserRole.manager;
    if (roleString == 'mentor') return UserRole.mentor;
    return UserRole.unknown; // Значение по умолчанию
  }
}
