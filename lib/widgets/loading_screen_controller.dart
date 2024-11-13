import 'package:flutter/material.dart';

typedef CloseLoadingScreen = bool Function();

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close; // to closs our dialog

  const LoadingScreenController({
    required this.close,
  });
}

class LoadingScreen {
  LoadingScreen._shareInstance();
  static final LoadingScreen _shared = LoadingScreen._shareInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
  }) {
    _controller = showOverlay(context: context);
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController? showOverlay({
    required BuildContext context,
  }) {
    final state = Overlay.of(context);

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        overlay.remove();
        return true;
      },
    );
  }
}
