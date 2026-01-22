import 'package:eduera_student/features/auth/domain/usecases/sign_in.dart';
import 'package:eduera_student/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:eduera_student/features/auth/domain/usecases/sign_up.dart';
import 'package:eduera_student/features/auth/presentation/bloc/auth_event.dart';
import 'package:eduera_student/features/auth/presentation/bloc/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final SignUp _signUp;
  final SignInWithGoogle _signInWithGoogle;

  AuthBloc(this._signIn, this._signUp, this._signInWithGoogle)
    : super(AuthInitial()) {
    // Sign In
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _signIn(event.email, event.password);
        if (user != null) {
          await _saveUserDetails(user);
          emit(AuthSuccess(user: user));
        } else {
          emit(AuthFailure("Authentication failed"));
        }
      } catch (e) {
        emit(AuthFailure("Login error: ${e.toString()}"));
      }
    });

    // Sign Up
    on<SignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _signUp(
          event.email,
          event.password,
          event.name,
          event.phone,
        );
        if (user != null) {
          await _saveUserDetails(user, name: event.name, phone: event.phone);
          emit(AuthSuccess(user: user));
        } else {
          emit(AuthFailure("Signup failed"));
        }
      } catch (e) {
        emit(AuthFailure("Signup error: ${e.toString()}"));
      }
    });

    // Google Sign-In
    on<GoogleSignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _signInWithGoogle();
        if (user != null) {
          await _saveUserDetails(user);
          emit(AuthSuccess(user: user));
        } else {
          emit(AuthFailure("Google Sign-In failed"));
        }
      } catch (e) {
        emit(AuthFailure("Google Sign-In error: ${e.toString()}"));
      }
    });

    // Forgot Password
    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
        emit(AuthSuccess(message: "Password reset email sent successfully"));
      } catch (e) {
        emit(AuthFailure("Reset email error: ${e.toString()}"));
      }
    });
  }

  Future<void> _saveUserDetails(
    User user, {
    String? name,
    String? phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', user.uid);
    await prefs.setString('user_email', user.email ?? '');
    if (name != null) await prefs.setString('user_name', name);
    if (phone != null) await prefs.setString('user_phone', phone);
  }
}
