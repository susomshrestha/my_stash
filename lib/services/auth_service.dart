import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_stash/pages/home.dart';
import 'package:my_stash/pages/login.dart';
import 'package:my_stash/services/toast_service.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> register(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ToastService.showCustomToast(context, "Registration successful.",
          type: 'success');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ToastService.showCustomToast(context, "The password is too weak.",
            type: 'error');
      } else if (e.code == 'email-already-in-use') {
        ToastService.showCustomToast(context, "Email is already in use.",
            type: 'error');
      }
    } catch (e) {
      ToastService.showCustomToast(
          context, "Failed to register. Please Try Again.",
          type: 'error');
    }
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      ToastService.showCustomToast(context, "Registration successful.",
          type: 'success');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ToastService.showCustomToast(context, "User is not registered.",
            type: "error");
      } else if (e.code == 'wrong-password') {
        ToastService.showCustomToast(context, "Email/Password is invalid.",
            type: "error");
      }
    } catch (e) {
      ToastService.showCustomToast(
          context, "Failed to Login. Please try again.",
          type: "error");
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Check if the sign-in was canceled or failed
      if (googleUser == null) {
        // User canceled the sign-in, handle accordingly
        ToastService.showCustomToast(context, "Sign in aborted by user.",
            type: 'error');
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null || googleAuth.accessToken == null) {
        // Authentication failed, handle accordingly
        ToastService.showCustomToast(
            context, "Failed to authenticate with Google",
            type: 'error');
        return;
      }

      if (context.mounted) {
        ToastService.showCustomToast(context, "Sign in successful.",
            type: 'success');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.showCustomToast(context, e.toString(), type: 'error');
      }
    }
  }

  // Sign out from Google
  Future<void> signOutFromGoogle(BuildContext context) async {
    try {
      // TODO: check if user login in provider
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        ToastService.showCustomToast(context, "Successfully signed out.",
            type: 'success');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.showCustomToast(
            context, "Error signing out: ${e.toString()}",
            type: 'error');
      }
    }
  }
}
