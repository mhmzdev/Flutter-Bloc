part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  final User user;
  final String errorMsg;
  const AuthState({this.user, this.errorMsg});

  @override
  List<Object> get props => [user, errorMsg];
}

// default state
class AuthDefault extends AuthState {}

// login states
class AuthLoginLoading extends AuthState {
  const AuthLoginLoading();
}

class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess({User user}) : super(user: user);
}

class AuthLoginError extends AuthState {
  const AuthLoginError({String error}) : super(errorMsg: error);
}

// Signup states
class AuthSignUpLoading extends AuthState {
  const AuthSignUpLoading();
}

class AuthSignUpSuccess extends AuthState {
  const AuthSignUpSuccess();
}

class AuthSignUpError extends AuthState {
  final String err;
  const AuthSignUpError(this.err);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthSignUpError && other.err == err;
  }

  @override
  int get hashCode => err.hashCode;
}

// forgot password states
class AuthForgotPasswordLoading extends AuthState {
  const AuthForgotPasswordLoading();
}

class AuthForgotPasswordSuccess extends AuthState {
  const AuthForgotPasswordSuccess();
}

class AuthForgotPasswordError extends AuthState {
  final String err;
  const AuthForgotPasswordError(this.err);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthForgotPasswordError && other.err == err;
  }

  @override
  int get hashCode => err.hashCode;
}

// gmail auth states
class AuthGmailLoading extends AuthState {
  const AuthGmailLoading();
}

class AuthGmailSuccess extends AuthState {
  const AuthGmailSuccess({User user}) : super(user: user);
}

class AuthGmailError extends AuthState {
  const AuthGmailError({String error}) : super(errorMsg: error);
}

// facebook auth states
class AuthFBLoading extends AuthState {
  const AuthFBLoading();
}

class AuthFBSuccess extends AuthState {
  const AuthFBSuccess({User user}) : super(user: user);
}

class AuthFBError extends AuthState {
  const AuthFBError({String error}) : super(errorMsg: error);
}

// logout state
class AuthLogOut extends AuthState {
  const AuthLogOut();
}
