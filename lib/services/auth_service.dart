import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_stash/exceptions/custom_exception.dart';
import 'package:my_stash/models/user_model.dart';
import 'package:my_stash/pages/login.dart';
import 'package:my_stash/services/toast_service.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> register(String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Create a new document in Firestore for the registered user
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'displayName': name,
          'createdAt': Timestamp.now(),
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException("The password is too weak.");
      } else if (e.code == 'email-already-in-use') {
        throw CustomException("Email is already in use.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        return UserModel(
            id: user.uid,
            displayName: user.displayName ?? 'User',
            email: user.email!,
            photoUrl: user.photoURL ?? '');
      }

      throw CustomException("User not found");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw CustomException("Email/Password is invalid.");
      }
    } catch (e) {
      rethrow;
    } finally {
      throw CustomException("Failed. Please Try Again Later.");
    }
  }

  // Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Check if the sign-in was canceled or failed
      if (googleUser == null) {
        // User canceled the sign-in, handle accordingly
        throw CustomException("Sign in aborted by user.");
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null || googleAuth.accessToken == null) {
        // Authentication failed, handle accordingly

        throw CustomException("Failed to authenticate with Google");
      }

      return UserModel(
          id: googleUser.id,
          displayName: googleUser.displayName ?? 'User',
          email: googleUser.email,
          photoUrl: googleUser.photoUrl ?? '');
    } catch (e) {
      rethrow;
    }
  }

  // Sign out from Google
  Future<void> singOut(BuildContext context) async {
    try {
      // TODO: check if user login in provider
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        ToastService.showToast("Successfully signed out.", type: 'success');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.showToast("Error signing out: ${e.toString()}",
            type: 'error');
      }
    }
  }
}
