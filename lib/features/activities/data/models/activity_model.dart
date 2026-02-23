import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rolab_crm/features/activities/domain/entities/activity.dart';

class ActivityLogModel extends ActivityLog {
  const ActivityLogModel({
    required super.id,
    required super.type,
    required super.title,
    required super.description,
    required super.userName,
    required super.createdAt,
  });

  factory ActivityLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityLogModel(
      id: doc.id,
      type: data['type'] ?? 'other',
      title: data['title'] ?? 'Действие',
      description: data['description'] ?? '',
      userName: data['userName'] ?? 'Пользователь',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'title': title,
      'description': description,
      'userName': userName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
