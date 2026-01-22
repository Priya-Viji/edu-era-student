import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduera_student/features/profile/data/services/student_service.dart';
import 'package:eduera_student/features/profile/domain/models/student_model.dart';
import 'package:eduera_student/services/cloudinary_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthDataSource {
  Future<User?> signUp(
    String email,
    String password,
    String name,
    String phone,
  );
  Future<User?> login(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logout();
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthDataSourceImpl(this._firebaseAuth, [GoogleSignIn? googleSignIn])
    : _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<User?> signUp(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
  String studentId=user!.uid;
    await user.updateDisplayName(name);

    final student = StudentModel(
      studentId: studentId,
      name: name,
      email: email,
      phone: phone,
      profileImageUrl: null, // no image at signup
      status: StudentStatus.active,
      createdAt: DateTime.now(),
    );

    await StudentService().createStudent(student);
      return user;
  }

  @override
  Future<User?> login(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result = await _firebaseAuth.signInWithCredential(credential);
    final user = result.user;

    if (user != null) {
      // Upload Google profile image to Cloudinary
      String? imageUrl;
      if (user.photoURL != null) {
        imageUrl = await CloudinaryService().uploadImageFromUrl(
          user.photoURL!,
          "students/${user.uid}",
        );
      }

      // Save student details in Firestore (only if not exists)
      final docRef = FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        final student = StudentModel(
          studentId: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          profileImageUrl: imageUrl,
          status: StudentStatus.active,
          createdAt: DateTime.now(),
        );
        await StudentService().createStudent(student);
      }
    }
    return user;
  }
}
