import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthDefault());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // login
  Future login(String email, String password) async {
    emit(const AuthLoginLoading());
    try {
      User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) {
        emit(AuthLoginSuccess(user: user));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthLoginError(error: e.message));
    }
  }

  // signUp
  Future signUp(String name, String email, String password) async {
    emit(const AuthSignUpLoading());
    try {
      User user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        user.updateDisplayName(name);
        emit(const AuthSignUpSuccess());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthSignUpError(e.message));
    }
  }

  // forgort password
  Future forgotPassword(String email) async {
    emit(const AuthForgotPasswordLoading());
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      emit(const AuthForgotPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthForgotPasswordError(e.message));
    }
  }

  // gmail auth
  Future gmailAuth() async {
    emit(const AuthGmailLoading());
    try {
      final GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      if (_googleUser == null) {
        emit(AuthDefault());
      } else {
        final GoogleSignInAuthentication _googleAuth =
            await _googleUser.authentication;

        final AuthCredential _credential = GoogleAuthProvider.credential(
            idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);

        User _user =
            (await _firebaseAuth.signInWithCredential(_credential)).user;

        if (_user != null) {
          emit(AuthGmailSuccess(user: _user));
        }
      }
    } catch (e) {
      emit(AuthGmailError(error: e.toString()));
    }
  }

  // gmail logout
  Future gmailLogout() async {
    await _googleSignIn.signOut();
    emit(const AuthLogOut());
  }

  // facebook auth
  Future facebookAuth() async {
    emit(const AuthFBLoading());
    try {
      final LoginResult _loginResult = await _facebookAuth.login();
      final OAuthCredential _oAuthCreds =
          FacebookAuthProvider.credential(_loginResult.accessToken.token);
      User _user = (await _firebaseAuth.signInWithCredential(_oAuthCreds)).user;
      if (_user != null) {
        emit(AuthFBSuccess(user: _user));
      }
    } catch (e) {
      emit(AuthFBError(error: e.toString()));
    }
  }

  Future facebookLogout() async {
    await _facebookAuth.logOut();
    emit(const AuthLogOut());
  }

  // auth logout
  Future logOut() async {
    await _firebaseAuth.signOut();
    emit(const AuthLogOut());
  }
}
