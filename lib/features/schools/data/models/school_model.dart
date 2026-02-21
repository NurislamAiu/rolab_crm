import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/school.dart';

class SchoolModel extends School {
  const SchoolModel({
    required super.id,
    required super.name,
    required super.address,
    required super.createdAt,
  });

  // Фабричный конструктор для создания экземпляра SchoolModel из документа Firestore
  factory SchoolModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SchoolModel(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      // Преобразуем Timestamp из Firestore в DateTime
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Метод для преобразования SchoolModel в Map для записи в Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
