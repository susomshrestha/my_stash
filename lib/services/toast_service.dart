import 'package:flutter/material.dart';

class ToastService {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void showToast(String message, {String? type}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Find the ScaffoldMessengerState
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Remove current toast if visible
    if (_isVisible) {
      _overlayEntry?.remove();
      _isVisible = false;
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
        content: _ToastContent(message: message, type: type),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

class _ToastContent extends StatelessWidget {
  final String message;
  final String? type;

  const _ToastContent({
    required this.message,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    Icon icon;
    switch (type) {
      case 'success':
        icon = const Icon(Icons.check_circle, color: Colors.green);
        break;
      case 'error':
        icon = const Icon(Icons.warning, color: Colors.red);
        break;
      default:
        icon = const Icon(Icons.info, color: Colors.blue);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
