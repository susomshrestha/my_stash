import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_stash/pages/home.dart';
import 'package:my_stash/pages/login.dart';
import 'package:my_stash/services/toast_service.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
      await _googleSignIn.signOut();
      if (context.mounted) {
        ToastService.showCustomToast(context, "Successfully signed out.",
            type: 'success');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      print(e);
      if (context.mounted) {
        ToastService.showCustomToast(
            context, "Error signing out: ${e.toString()}",
            type: 'error');
      }
    }
  }
}
