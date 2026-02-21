import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.schoolId,
    required super.fullName,
    required super.dateOfBirth,
    required super.parentFullName,
    required super.parentPhoneNumber,
    required super.createdAt,
    super.groupId,
  });

  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      id: doc.id,
      schoolId: data['schoolId'],
      groupId: data['groupId'],
      fullName: data['fullName'],
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      parentFullName: data['parentFullName'],
      parentPhoneNumber: data['parentPhoneNumber'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'schoolId': schoolId,
      'groupId': groupId,
      'fullName': fullName,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'parentFullName': parentFullName,
      'parentPhoneNumber': parentPhoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
