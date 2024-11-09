import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_stash/services/crypto_service.dart';

class KeyService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CryptoService _cryptoService = CryptoService();

  Future<bool> hasKeyInSecureStorage(String userId) async {
    final key = await _secureStorage.read(key: 'encryption_key_$userId');
    return key != null;
  }

  Future<String?> getKeyFromFirebase(String userId) async {
    final docSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('encryption')
        .get();

    if (docSnapshot.exists) {
      return docSnapshot.data()?['key'] as String?;
    }
    return null;
  }

  Future<String?> getKeyFromSecureStorage(String userId) async {
    final key = await _secureStorage.read(key: 'encryption_key_$userId');
    return key;
  }

  Future<bool> hasKeyInFirebase(String userId) async {
    final key = await getKeyFromFirebase(userId);
    return key != null;
  }

  Future<void> saveKeyToSecureStorage(String userId, Uint8List key) async {
    await _secureStorage.write(
      key: 'encryption_key_$userId',
      value: base64Encode(key),
    );
  }

  Future<void> saveKeyToFirebase(String userId, Uint8List key) async {
    // encrypt key to save to cloud
    final wrappedKey = _cryptoService.wrapKey(key);

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('encryption')
        .set({
      'key': wrappedKey,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveKey(String userId, Uint8List key) async {
    // Save to secure storage
    await saveKeyToSecureStorage(userId, key);
    // Save to Firebase
    await saveKeyToFirebase(userId, key);
  }

  Future<String?> syncKeyFromFirebase(String userId) async {
    try {
      // Get key from Firebase
      String? firebaseKey = await getKeyFromFirebase(userId);

      if (firebaseKey != null) {
        final unwrappedKey = _cryptoService.unwrapKey(firebaseKey);
        // Save to secure storage
        await saveKeyToSecureStorage(userId, unwrappedKey);
        return firebaseKey;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
