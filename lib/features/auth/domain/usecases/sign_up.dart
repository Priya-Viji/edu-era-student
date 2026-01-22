import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<User?> call(String email, String password, String name, String phone) {
    return repository.signUp(email, password, name, phone);
  }
}
