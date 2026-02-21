import 'package:equatable/equatable.dart';

// Enum для ролей пользователей
enum UserRole { admin, manager, mentor, unknown }

extension UserRoleExtension on UserRole {
  String toShortString() {
    return toString().split('.').last;
  }
}

class AppUser extends Equatable {
  final String uid;
  final String email;
  final String fullName;
  final UserRole role;
  final List<String> assignedSchoolIds;
  final List<String> assignedGroupIds;

  const AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    this.assignedSchoolIds = const [],
    this.assignedGroupIds = const [],
  });

  @override
  List<Object?> get props => [uid, email, fullName, role, assignedSchoolIds, assignedGroupIds];
}
