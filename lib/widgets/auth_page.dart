import 'package:flutter/material.dart';
import 'package:my_stash/services/auth_service.dart';

class AuthPage extends StatelessWidget {
  final Widget form;
  final Widget actionButton;
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  AuthPage({
    super.key,
    required this.form,
    required this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Stash',
                style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      form,
                      const SizedBox(
                        height: 40,
                      ),
                      actionButton,
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface, // Color of the line
                              thickness: 1, // Thickness of the line
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Or Login with',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface, // Color of the line
                              thickness: 1, // Thickness of the line
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          _googleAuthService.signInWithGoogle(context);
                        },
                        child: Image.asset(
                          'assets/icons/googleIcon.png',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
