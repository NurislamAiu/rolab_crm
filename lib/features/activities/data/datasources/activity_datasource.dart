import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rolab_crm/core/error/exceptions.dart';
import 'package:rolab_crm/features/activities/data/models/activity_model.dart';

abstract class ActivityDataSource {
  Stream<List<ActivityLogModel>> getRecentActivities();
  Future<void> logActivity(ActivityLogModel activity);
}

class ActivityDataSourceImpl implements ActivityDataSource {
  final FirebaseFirestore firestore;

  ActivityDataSourceImpl({required this.firestore});

  @override
  Stream<List<ActivityLogModel>> getRecentActivities() {
    try {
      return firestore.collection('activities')
          .orderBy('createdAt', descending: true)
          .limit(10) // Берем только 10 последних действий
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) => ActivityLogModel.fromFirestore(doc)).toList();
          });
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> logActivity(ActivityLogModel activity) async {
    try {
      await firestore.collection('activities').add(activity.toFirestore());
    } catch (e) {
      throw ServerException();
    }
  }
}
