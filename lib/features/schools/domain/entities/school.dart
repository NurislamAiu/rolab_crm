import 'package:equatable/equatable.dart';

class School extends Equatable {
  final String id;
  final String name;
  final String address;
  final DateTime createdAt;

  const School({
    required this.id,
    required this.name,
    required this.address,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, address, createdAt];
}
