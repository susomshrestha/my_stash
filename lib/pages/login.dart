import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_stash/exceptions/custom_exception.dart';
import 'package:my_stash/models/user_model.dart';
import 'package:my_stash/pages/home.dart';
import 'package:my_stash/pages/register.dart';
import 'package:my_stash/providers/user_provider.dart';
import 'package:my_stash/services/auth_service.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:my_stash/services/validator_service.dart';
import 'package:my_stash/widgets/auth_page.dart';
import 'package:my_stash/widgets/loading_screen_controller.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the state is removed
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!(_loginFormKey.currentState?.validate() ?? true)) {
      return;
    }
    LoadingScreen.instance().show(context: context);
    try {
      UserModel user = await _authService.login(
          _emailController.text, _passwordController.text);

      if (mounted) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(user);

        ToastService.showToast("Login successful.");

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } on CustomException catch (e) {
      ToastService.showToast(e.message, type: ToastificationType.error);
    } catch (e) {
      ToastService.showToast("Failed to Login. Please try again later.",
          type: ToastificationType.error);
    }
    LoadingScreen.instance().hide();
  }

  @override
  Widget build(BuildContext context) {
    final ValidatorService validator = ValidatorService();

    Widget loginForm = Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
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
            controller: _passwordController,
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
        ],
      ),
    );

    Widget loginActionBtn = Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: login,
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
              "Login",
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
            text: "Don't have an account? ",
            style: TextStyle(
                fontSize: 16, color: Theme.of(context).colorScheme.onSecondary),
            children: [
              TextSpan(
                text: 'Register',
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
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );

    return AuthPage(form: loginForm, actionButton: loginActionBtn);
  }
}
