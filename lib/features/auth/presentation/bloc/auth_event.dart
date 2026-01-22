abstract class AuthEvent {}
class SignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String phone;

  SignupRequested(
    this.email, 
    this.password,
    this.name,
    this.phone
    );
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  SignInRequested(this.email, this.password);
}

class GoogleSignInRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested(this.email);
}
