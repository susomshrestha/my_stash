import 'package:flutter/material.dart';
import 'package:my_stash/constants/strings.dart';
import 'package:my_stash/models/user_model.dart';
import 'package:my_stash/pages/home.dart';
import 'package:my_stash/pages/key_input.dart';
import 'package:my_stash/services/key_service.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:toastification/toastification.dart';

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
          ToastService.showToast(AppStrings.keySyncMsg);
          return true;
        }
      }

      return false;
    } catch (e) {
      ToastService.showToast(
        AppStrings.keySyncFailMsg,
        type: ToastificationType.error,
      );
      return false;
    }
  }

  Future<void> handleAuthenticatedNavigation(
    BuildContext context,
    UserModel user,
  ) async {
    bool hasKey = await _checkForKey(user.id);

    if (hasKey) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
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
