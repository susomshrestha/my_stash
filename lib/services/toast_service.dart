import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  static void showToast(String message,
      {ToastificationType type = ToastificationType.success}) {
    toastification.show(
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
      type: type,
      closeOnClick: true,
      dragToClose: true,
      style: ToastificationStyle.flatColored,
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
    );
  }
}
