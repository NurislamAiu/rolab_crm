import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/app_user_model.dart';

abstract class AuthFirebaseDataSource {
  Future<AppUserModel> getCurrentUser();
  Future<AppUserModel> loginWithEmail(String email, String password);
  Future<void> logout();
}

class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthFirebaseDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<AppUserModel> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw ServerException();
      }
      return _getUserData(firebaseUser.uid);
    } on FirebaseAuthException catch (e) {
      // Можно добавить обработку разных кодов ошибок (wrong-password и т.д.)
      throw ServerException();
    }
  }
  
  @override
  Future<AppUserModel> getCurrentUser() async {
     final firebaseUser = firebaseAuth.currentUser;
     if (firebaseUser == null) {
        throw CacheException(); // Используем CacheException, т.к. пользователь не найден локально
     }
     return _getUserData(firebaseUser.uid);
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  // Вспомогательный приватный метод для получения данных из Firestore
  Future<AppUserModel> _getUserData(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      // Это критическая ошибка: пользователь есть в Auth, но нет в Firestore
      throw ServerException();
    }
    return AppUserModel.fromFirestore(doc);
  }
}
