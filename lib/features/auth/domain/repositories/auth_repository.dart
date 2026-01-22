import 'package:eduera_student/features/auth/data/auth_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(
    String email,
    String password,
    String name,
    String phone,
  );
  Future<User?> signInWithGoogle();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<User?> signIn(String email, String password) {
    return _dataSource.login(email, password);
  }

  @override
  Future<User?> signUp(
    String email,
    String password,
    String name,
    String phone,
  ) {
    return _dataSource.signUp(email, password, name, phone);
  }

  @override
  Future<User?> signInWithGoogle() {
    return _dataSource.signInWithGoogle();
  }
  

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _dataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> logout() {
    return _dataSource.logout();
  }
}
