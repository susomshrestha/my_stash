import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/random/fortuna_random.dart';

class CryptoService {
  final SecureRandom _secureRandom = FortunaRandom();
  final Random _random = Random.secure();

  late final Digest _sha256Digest;
  late final PBKDF2KeyDerivator _pbkdf2KeyDerivator;
  final AESEngine _aesEngine = AESEngine();
  late final GCMBlockCipher _gcmBlockCipher;

  CryptoService() {
    _sha256Digest = SHA256Digest();
    _pbkdf2KeyDerivator = PBKDF2KeyDerivator(HMac(_sha256Digest, 64));
    _gcmBlockCipher = GCMBlockCipher(_aesEngine);

    // Seed the secure random
    final seed = _generateRandomSeed();
    _secureRandom.seed(KeyParameter(seed));
  }

  Uint8List _generateRandomSeed() {
    final seed = Uint8List(32);
    for (var i = 0; i < seed.length; i++) {
      seed[i] = _random.nextInt(256);
    }
    return seed;
  }

  Uint8List generateIV() {
    final iv = Uint8List(12);
    for (var i = 0; i < iv.length; i++) {
      iv[i] = _random.nextInt(256);
    }
    return iv;
  }

  Uint8List generateSalt() {
    final salt = Uint8List(16);
    for (var i = 0; i < salt.length; i++) {
      salt[i] = _random.nextInt(256);
    }
    return salt;
  }

  Uint8List deriveKey(String password) {
    const iterations = 10000;
    const desiredKeyLength = 32;

    final salt = generateSalt();

    final params = Pbkdf2Parameters(salt, iterations, desiredKeyLength);
    _pbkdf2KeyDerivator.init(params);

    final key = Uint8List(desiredKeyLength);
    final passwordBytes = utf8.encode(password);

    _pbkdf2KeyDerivator.process(passwordBytes);
    key.setAll(0, _pbkdf2KeyDerivator.process(passwordBytes));

    return key;
  }

  /// Encrypt with a provided key
  String encrypt(String plaintext, Uint8List key) {
    // generate a new iv
    final iv = generateIV();

    final params = AEADParameters(
        KeyParameter(key),
        128, // 16 bytes auth tag size
        iv,
        Uint8List(0));

    _gcmBlockCipher.init(true, params);

    final plaintextBytes = utf8.encode(plaintext);
    final ciphertextBytes = _gcmBlockCipher.process(plaintextBytes);

    // Return IV + ciphertext
    final cipherText = Uint8List.fromList([...iv, ...ciphertextBytes]);
    return base64Encode(cipherText);
  }

  /// Decrypt with a provided key
  String decrypt(String cipherText, Uint8List key) {
    final encrypted = Uint8List.fromList(base64Decode(cipherText));

    // Extract IV (first 12 bytes)
    final iv = encrypted.sublist(0, 12);

    // Extract ciphertext (remaining bytes)
    final ciphertextBytes = encrypted.sublist(12);

    final params = AEADParameters(KeyParameter(key), 128, iv, Uint8List(0));

    _gcmBlockCipher.init(false, params);

    try {
      final plaintextBytes = _gcmBlockCipher.process(ciphertextBytes);
      return utf8.decode(plaintextBytes);
    } catch (e) {
      throw Exception('Decryption failed: ${e.toString()}');
    }
  }

  // for wrapping the key used to encrypt users password
  Uint8List _deriveKeyWrappingKey() {
    const wrappingKeySalt =
        'MyStashKeyWrappingConstant2024'; // Change this to your own constant
    final salt = Uint8List.fromList(utf8.encode(wrappingKeySalt));

    const iterations = 10000;
    const desiredKeyLength = 32;

    final params = Pbkdf2Parameters(salt, iterations, desiredKeyLength);
    _pbkdf2KeyDerivator.init(params);

    final wrappingKey = Uint8List(desiredKeyLength);
    final baseKey = utf8
        .encode('MyStashKeyWrapping2024'); // Change this to your own constant

    _pbkdf2KeyDerivator.process(baseKey);
    wrappingKey.setAll(0, _pbkdf2KeyDerivator.process(baseKey));

    return wrappingKey;
  }

  /// Wraps (encrypts) a key for cloud storage
  String wrapKey(Uint8List keyToWrap) {
    final wrappingKey = _deriveKeyWrappingKey();
    return encrypt(base64Encode(keyToWrap), wrappingKey);
  }

  /// Unwraps (decrypts) a key from cloud storage
  Uint8List unwrapKey(String wrappedKey) {
    final wrappingKey = _deriveKeyWrappingKey();
    final unwrappedKeyBase64 = decrypt(wrappedKey, wrappingKey);
    return base64Decode(unwrappedKeyBase64);
  }
}
