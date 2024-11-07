import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_stash/exceptions/custom_exception.dart';
import 'package:my_stash/models/user_model.dart';

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
      } else {
        throw CustomException("User not found");
      }
    } on FirebaseAuthException catch (e) {
      throw CustomException("Email/Password is invalid.");
    } catch (e) {
      rethrow;
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

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      // Return the UserModel if sign-in was successful
      if (user != null) {
        // Check if user document exists and set it if not
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        DocumentSnapshot docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set(
              {
                'email': user.email,
                'displayName': user.displayName ?? 'User',
                'createdAt': Timestamp.now(),
                'photoUrl': user.photoURL
              },
              SetOptions(
                  merge:
                      true)); // Use merge to ensure document is created if absent
        }

        return UserModel(
          id: user.uid,
          displayName: user.displayName ?? 'User',
          email: user.email!,
          photoUrl: user.photoURL ?? '',
        );
      }

      throw CustomException("User not found");
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> singOut(BuildContext context) async {
    try {
      // TODO: check if user login in provider
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw CustomException("Something went wrong.");
    }
  }
}
