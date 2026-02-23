import 'package:equatable/equatable.dart';

class ActivityLog extends Equatable {
  final String id;
  final String type; // 'login', 'add_school', 'add_student'
  final String title;
  final String description;
  final String userName;
  final DateTime createdAt;

  const ActivityLog({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.userName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, type, title, description, userName, createdAt];
}
