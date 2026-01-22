import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/home/data/models/mentor_model.dart';

class MentorRemoteDataSource {
  final FirebaseFirestore firestore;
  MentorRemoteDataSource(this.firestore);

  Future<MentorModel> getMentorById(String mentorId) async {
    final doc = await firestore.collection('mentor_profiles').doc(mentorId).get();
    return MentorModel.fromFirestore(doc);
  }
}
