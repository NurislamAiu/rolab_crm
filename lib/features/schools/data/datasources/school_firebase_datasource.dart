import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/school_model.dart';

abstract class SchoolFirebaseDataSource {
  Stream<List<SchoolModel>> getSchools();
  Future<void> addSchool(SchoolModel school);
  Future<void> updateSchool(SchoolModel school); // <--- Добавил этот метод
}

class SchoolFirebaseDataSourceImpl implements SchoolFirebaseDataSource {
  final FirebaseFirestore firestore;

  SchoolFirebaseDataSourceImpl({required this.firestore});

  @override
  Stream<List<SchoolModel>> getSchools() {
    try {
      return firestore.collection('schools')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => SchoolModel.fromFirestore(doc)).toList();
        });
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> addSchool(SchoolModel school) async {
    try {
      await firestore.collection('schools').add(school.toFirestore());
    } catch (e) {
      throw ServerException();
    }
  }

  // <--- И реализовал его
  @override
  Future<void> updateSchool(SchoolModel school) async {
    try {
      await firestore.collection('schools').doc(school.id).update(school.toFirestore());
    } catch (e) {
      throw ServerException();
    }
  }
}
