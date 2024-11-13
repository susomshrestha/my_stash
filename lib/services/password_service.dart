import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_stash/constants/strings.dart';
import 'package:my_stash/exceptions/custom_exception.dart';
import 'package:my_stash/models/password_model.dart';

class PasswordService {
  final db = FirebaseFirestore.instance;

  Future<PasswordModel> addPassword(
      PasswordModel password, String userId) async {
    try {
      final querySnapshot = await db
          .collection("users")
          .doc(userId)
          .collection("passwords")
          .where("title", isEqualTo: password.title)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw CustomException(
            "A password with the title '${password.title}' already exists.");
      }
      final addedPasswordRef = await db
          .collection("users")
          .doc(userId)
          .collection("passwords")
          .add(password.toJson());

      final addedPasswordSnapshot = await addedPasswordRef.get();

      // Check if the document exists
      if (addedPasswordSnapshot.exists) {
        final addedPasswordData = addedPasswordSnapshot.data();
        return PasswordModel.fromJson(addedPasswordData!, addedPasswordRef.id);
      } else {
        throw CustomException("Password cannot be found.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PasswordModel> updatePassword(
      PasswordModel password, String userId, String passwordId) async {
    try {
      // Update the password document
      await db
          .collection("users")
          .doc(userId)
          .collection("passwords")
          .doc(passwordId)
          .update(password.toJson());

      // Retrieve the updated password document
      final updatedPasswordSnapshot = await db
          .collection("users")
          .doc(userId)
          .collection("passwords")
          .doc(passwordId)
          .get();

      // Check if the document exists
      if (updatedPasswordSnapshot.exists) {
        final updatedPasswordData = updatedPasswordSnapshot.data();

        // Convert the snapshot back to a PasswordModel
        return PasswordModel.fromJson(updatedPasswordData!, passwordId);
      } else {
        throw CustomException(AppStrings.passwordNotFound);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePassword(String userId, String passwordId) async {
    try {
      await db
          .collection("users")
          .doc(userId)
          .collection("passwords")
          .doc(passwordId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PasswordModel>> searchPassword(
      String userId, String searchQuery) async {
    try {
      final snapshot = await db
          .collection("users")
          .doc(userId)
          .collection("passwords")
          .where("title", isGreaterThanOrEqualTo: searchQuery)
          .where("title",
              isLessThanOrEqualTo:
                  '$searchQuery\uf8ff') // Ensures search is case-insensitive and matches prefix
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PasswordModel.fromJson(data, doc.id);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PasswordModel>> getPasswordList(String userId) async {
    try {
      // await db.collection('users').get();

      final snapshot = await db
          .collection('users')
          .doc(userId)
          .collection('passwords')
          .get();

      // Create a list of PasswordModel from the documents
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PasswordModel.fromJson(data, doc.id);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
