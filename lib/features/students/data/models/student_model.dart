import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rolab_crm/features/students/domain/entities/student.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.schoolId,
    super.groupId,
    required super.fullName,
    required super.dateOfBirth,
    required super.parentFullName,
    required super.parentPhoneNumber,
    super.iin,
    super.className,
    required super.createdAt,
  });

  factory StudentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Делаем data nullable на случай, если документ пуст

    if (data == null) {
      return StudentModel(
        id: doc.id,
        schoolId: '', // Fallback value
        fullName: 'Неизвестный студент', // Fallback value
        dateOfBirth: DateTime.now(), // Fallback value
        parentFullName: 'Неизвестный родитель', // Fallback value
        parentPhoneNumber: '', // Fallback value
        createdAt: DateTime.now(), // Fallback value
      );
    }

    // Безопасное чтение с fallback-значениями, если в Firestore пришел null
    return StudentModel(
      id: doc.id,
      schoolId: data['schoolId']?.toString() ?? '', 
      groupId: data['groupId']?.toString(),
      fullName: data['fullName']?.toString() ?? 'Неизвестный студент', 
      dateOfBirth: (data['dateOfBirth'] as Timestamp?)?.toDate() ?? DateTime.now(), 
      parentFullName: data['parentFullName']?.toString() ?? 'Неизвестный родитель', 
      parentPhoneNumber: data['parentPhoneNumber']?.toString() ?? '', 
      // Приводим iin и className к String? (на случай если они сохранились как Number)
      iin: data['iin']?.toString(), 
      className: data['className']?.toString(), 
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(), 
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
      'iin': iin,
      'className': className,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
