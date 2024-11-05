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
}
