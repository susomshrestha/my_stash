import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_stash/pages/login.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:my_stash/services/validator_service.dart';
import 'package:my_stash/widgets/auth_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ToastService.init(context);
    final ValidatorService validator = ValidatorService();

    Widget registerForm = Form(
      key: _registerFormKey,
      child: Column(
        children: [
          TextFormField(
            validator: validator.emailValidator,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.mail_outline,
                  color: Theme.of(context).colorScheme.onSecondary),
              hintText: 'Email',
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
              // Border customization
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary), // Default (inactive) color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: validator.passwordValidator,
            obscureText: true,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.password,
                  color: Theme.of(context).colorScheme.onSecondary),
              hintText: 'Password',
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
              // Border customization
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary), // Default (inactive) color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: true,
            validator: validator.confirmPasswordValidator,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.password_rounded,
                  color: Theme.of(context).colorScheme.onSecondary),
              hintText: 'Confirm Password',
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
              // Border customization
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary), // Default (inactive) color
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );

    // Define the action button for registration
    Widget registerActionBtn = Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (!(_registerFormKey.currentState?.validate() ?? true)) {
                return;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primary, // Use the theme's primary color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 16), // Button height
            ),
            child: Text(
              "Register",
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        RichText(
          text: TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary, fontSize: 16),
            children: [
              TextSpan(
                text: 'Login',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Use the primary color for "Register"
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration
                      .underline, // To make it look like a hyperlink
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );

    return AuthPage(form: registerForm, actionButton: registerActionBtn);
  }
}
