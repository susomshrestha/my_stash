import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastService {
  static final FToast fToast = FToast();

  static void init(BuildContext context) {
    fToast.init(context);
  }

  static void showCustomToast(BuildContext context, String message,
      {String? type}) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;
    Icon icon;

    switch (type) {
      case 'success':
        icon = const Icon(Icons.check_circle, color: Colors.green);
        break;
      case 'danger':
        icon = const Icon(Icons.warning, color: Colors.red);
        break;
      default:
        icon = const Icon(Icons.info, color: Colors.blue);
        break;
    }

    // Create custom toast widget
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      width: screenWidth * 0.9, // 90% of screen width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).colorScheme.onSurface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );

    // Show the toast
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
