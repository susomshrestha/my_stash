import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_stash/exceptions/custom_exception.dart';
import 'package:my_stash/models/password_model.dart';

class PasswordService {
  final db = FirebaseFirestore.instance;

  Future<void> addPassword(PasswordModel password, String userId) async {
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
      await db
          .collection("users")
          .doc(userId)
          .collection("passwords")
          .add(password.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PasswordModel>> getPasswordTitlesWithIds(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
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
