import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rolab_crm/core/error/exceptions.dart';
import 'package:rolab_crm/features/students/data/models/student_model.dart';

abstract class StudentFirebaseDataSource {
  Stream<List<StudentModel>> getStudentsInSchool(String schoolId);
  Future<void> addStudent(StudentModel student);
}

class StudentFirebaseDataSourceImpl implements StudentFirebaseDataSource {
  final FirebaseFirestore firestore;

  StudentFirebaseDataSourceImpl({required this.firestore});

  @override
  Stream<List<StudentModel>> getStudentsInSchool(String schoolId) {
    try {
      return firestore
          .collection('students')
          .where('schoolId', isEqualTo: schoolId) // <-- Ключевой запрос
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => StudentModel.fromFirestore(doc)).toList());
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> addStudent(StudentModel student) async {
    try {
      await firestore.collection('students').add(student.toFirestore());
    } catch (e) {
      throw ServerException();
    }
  }
}
