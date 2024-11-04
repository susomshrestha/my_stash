// validators.dart
import 'package:flutter/material.dart';

class ValidatorService {
  String? password;

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is Required';
    }
    return null; // Return null if valid
  }

  String? emailValidator(String? value) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (value == null || value.isEmpty) {
      return 'Email is Required';
    } else if (!emailRegExp.hasMatch(value)) {
      return 'Invalid Email Address';
    }
    return null; // Return null if the email is valid
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is Required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    password = value;
    return null; // Return null if valid
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is Required';
    } else if (value != password) {
      return 'Passwords do not match';
    }
    return null; // Return null if valid
  }
}
