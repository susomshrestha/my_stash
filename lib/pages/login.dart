import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/icons/myStash.png'),
                ),
              ),
            ),
          ),
          Expanded(
              child: Column(
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'To',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'MYSTASH',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20), // Spacing between text and button
              // Flat Button for Google Login
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // Reduce padding
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login with Google',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 8), // Add space between text and icon
                    Image.asset(
                      'assets/icons/googleIcon.png', // Ensure this path is correct
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
