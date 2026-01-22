// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:eduera_student/features/home/data/models/mentor_model.dart';

// class MentorRepository {
//   final FirebaseFirestore firestore;

//   MentorRepository({required this.firestore});

//  Future<List<MentorModel>> fetchMentors() async {
//     final snapshot = await firestore.collection('mentor_profiles').get();
//     return snapshot.docs.map((doc) => MentorModel.fromFirestore(doc)).toList();
//   }


// }
