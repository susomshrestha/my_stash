import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_stash/constants/strings.dart';
import 'package:my_stash/exceptions/custom_exception.dart';
import 'package:my_stash/pages/login.dart';
import 'package:my_stash/services/auth_service.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:my_stash/services/validator_service.dart';
import 'package:my_stash/widgets/auth_page.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the state is removed
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (!(_registerFormKey.currentState?.validate() ?? true)) {
      return;
    }
    try {
      await _authService.register(_emailController.text,
          _passwordController.text, _nameController.text);

      ToastService.showToast(AppStrings.successRegister);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on CustomException catch (ce) {
      ToastService.showToast(ce.toString(), type: ToastificationType.error);
    } catch (e) {
      ToastService.showToast(AppStrings.failedToRegister,
          type: ToastificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ValidatorService validator = ValidatorService();

    Widget registerForm = Form(
      key: _registerFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            validator: (value) =>
                validator.requiredFieldValidator(value, AppStrings.name),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_2_outlined,
                  color: Theme.of(context).colorScheme.onSecondary),
              hintText: AppStrings.name,
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
            controller: _emailController,
            validator: validator.emailValidator,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.mail_outline,
                  color: Theme.of(context).colorScheme.onSecondary),
              hintText: AppStrings.email,
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
              hintText: AppStrings.password,
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
              hintText: AppStrings.confirmPassword,
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
            onPressed: submitForm,
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
              AppStrings.register,
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
            text: AppStrings.alreadyAccountMsg,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary, fontSize: 16),
            children: [
              TextSpan(
                text: AppStrings.login,
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
