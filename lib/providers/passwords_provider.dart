import 'package:flutter/material.dart';
import 'package:my_stash/models/password_model.dart';

class PasswordsProvider with ChangeNotifier {
  List<PasswordModel> _passwordList = [];
  List<PasswordModel> _cachedPasswordList = [];

  List<PasswordModel> get passwordList => _passwordList;
  List<PasswordModel> get cachedPasswordList => _cachedPasswordList;

  PasswordModel? _password;

  PasswordModel? get password => _password;

  void setPasswordList(List<PasswordModel> pwdList) {
    _passwordList = pwdList;
    notifyListeners();
  }

  void setCachedPasswordList(List<PasswordModel> pwdList) {
    _cachedPasswordList = [...pwdList];
    notifyListeners();
  }

  void addNewPassword(PasswordModel pwd) {
    _passwordList = [pwd, ..._passwordList];
    notifyListeners();
  }

  void deletePassword(String id) {
    final index = _passwordList.indexWhere((element) => element.id == id);
    if (index > -1) {
      _passwordList.removeAt(index);
    }
    notifyListeners();
  }

  void clearPassswordList() {
    _passwordList = [];
    notifyListeners();
  }

  void setPassword(PasswordModel pwd) {
    _password = pwd;
    notifyListeners();
  }

  void clearPasssword() {
    _password = null;
    notifyListeners();
  }

  void clearAll() {
    _password = null;
    _passwordList = [];
    _cachedPasswordList = [];
    notifyListeners();
  }
}
