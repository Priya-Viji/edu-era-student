import 'package:cloud_firestore/cloud_firestore.dart';

class MentorModel {
  final String id;
  final String name;
  final List<String> expertise;
  final String? photoUrl;
  final String? email;
  final String? jobTitle;

  const MentorModel({
    required this.id,
    required this.name,
    required this.expertise,
    this.photoUrl,
    this.email,
    this.jobTitle,
  });

  factory MentorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MentorModel(
      id: doc.id,
      name: data['name'] ?? '',
      expertise: List<String>.from(data['expertise'] ?? []),
      photoUrl: data['profilePic'] ?? '',
      email: data['email'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
    );
  }
}
