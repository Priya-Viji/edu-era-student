import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String name;
  final String icon;

  CategoryModel({required this.name, required this.icon});

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      name: data['label'] ?? '',
      icon: data['icon'] ?? 'category',
    );
  }
}
