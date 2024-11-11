import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:my_stash/models/password_model.dart';
import 'package:my_stash/services/crypto_service.dart';
import 'package:my_stash/services/key_service.dart';
import 'package:my_stash/services/password_service.dart';

class PasswordFormService {
  final KeyService _keyService = KeyService();
  final CryptoService _cryptoService = CryptoService();
  final PasswordService _passwordService = PasswordService();

  Future<PasswordModel> addNewPassword({
    required String userId,
    required String title,
    required String username,
    required String email,
    required String password,
    required List<QuestionAnswerModel> extraFields,
  }) async {
    final key = await _keyService.getKeyFromSecureStorage(userId);
    final encryptedPassword = _cryptoService.encrypt(
        password, Uint8List.fromList(base64Decode(key!)));
    for (var questionAnswer in extraFields) {
      questionAnswer.answer = _cryptoService.encrypt(
          questionAnswer.answer, Uint8List.fromList(base64Decode(key)));
    }

    return await _passwordService.addPassword(
        PasswordModel(
            title: title,
            username: username,
            email: email,
            password: encryptedPassword,
            extra: extraFields),
        userId);
  }

  bool compareLists(
      List<QuestionAnswerModel> list1, List<QuestionAnswerModel> list2) {
    // check length
    if (list1.length != list2.length) return false;

    // check each element
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].question != list2[i].question ||
          list1[i].answer != list2[i].answer) {
        return false;
      }
    }

    return true;
  }

  Future<PasswordModel> updateExistingPassword({
    required String userId,
    required PasswordModel oldPassword,
    required String title,
    required String username,
    required String email,
    required String password,
    required List<QuestionAnswerModel> editedExtraFields,
  }) async {
    final key = await _keyService.getKeyFromSecureStorage(userId);
    var encryptedPassword = password;
    if (password != oldPassword.password) {
      encryptedPassword = _cryptoService.encrypt(
          password, Uint8List.fromList(base64Decode(key!)));
    }

    final existingFieldsMap = {
      for (var field in oldPassword.extra) field.question: field.answer
    };

    final updatedFields = <QuestionAnswerModel>[];

    for (var editedField in editedExtraFields) {
      String finalAnswer;
      final existingAnswer = existingFieldsMap[editedField.question];

      if (existingAnswer != null) {
        if (editedField.answer != existingAnswer) {
          // answer changed
          finalAnswer = _cryptoService.encrypt(
              editedField.answer, Uint8List.fromList(base64Decode(key!)));
        } else {
          // answer unchanged
          finalAnswer = existingAnswer;
        }
      } else {
        // new field
        finalAnswer = _cryptoService.encrypt(
            editedField.answer, Uint8List.fromList(base64Decode(key!)));
      }

      updatedFields.add(QuestionAnswerModel(
        question: editedField.question,
        answer: finalAnswer,
      ));
    }

    return await _passwordService.updatePassword(
        PasswordModel(
            title: title,
            username: username,
            email: email,
            password: encryptedPassword,
            extra: updatedFields),
        userId,
        oldPassword.id!);
  }
}
