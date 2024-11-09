import 'package:flutter/material.dart';
import 'package:my_stash/models/user_model.dart';
import 'package:my_stash/pages/home.dart';
import 'package:my_stash/pages/key_input.dart';
import 'package:my_stash/services/key_service.dart';
import 'package:my_stash/services/toast_service.dart';

class NavigationService {
  final KeyService _keyService = KeyService();

  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal();

  Future<bool> _checkForKey(String userId) async {
    try {
      // First check in secure storage
      bool hasKeyInStorage = await _keyService.hasKeyInSecureStorage(userId);
      if (hasKeyInStorage) {
        return true;
      }

      // If not in storage, check in Firebase
      bool hasKeyInFirebase = await _keyService.hasKeyInFirebase(userId);

      // If key exists in Firebase but not in storage, sync it
      if (hasKeyInFirebase) {
        String? syncedKey = await _keyService.syncKeyFromFirebase(userId);
        if (syncedKey != null) {
          ToastService.showToast(
            "Encryption key synchronized from cloud",
            type: "success",
          );
          return true;
        }
      }

      return false;
    } catch (e) {
      ToastService.showToast(
        "Error checking encryption key. Please try again.",
        type: "error",
      );
      return false;
    }
  }

  Future<void> handleAuthenticatedNavigation(
    BuildContext context,
    UserModel user, {
    bool replace = true,
  }) async {
    bool hasKey = await _checkForKey(user.id);

    if (hasKey) {
      if (replace) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KeyInputPage(userId: user.id),
        ),
      );
    }
  }
}
