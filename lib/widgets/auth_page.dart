import 'package:flutter/material.dart';
import 'package:my_stash/constants/strings.dart';
import 'package:my_stash/exceptions/custom_exception.dart';
import 'package:my_stash/models/user_model.dart';
import 'package:my_stash/providers/user_provider.dart';
import 'package:my_stash/services/auth_service.dart';
import 'package:my_stash/services/navigation_service.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:my_stash/widgets/loading_screen_controller.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class AuthPage extends StatelessWidget {
  final Widget form;
  final Widget actionButton;
  final AuthService _authService = AuthService();
  final NavigationService _navigationService = NavigationService();

  AuthPage({
    super.key,
    required this.form,
    required this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    void signInWithGoogle(BuildContext context) async {
      LoadingScreen.instance().show(context: context);
      try {
        UserModel user = await _authService.signInWithGoogle();

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(user);

        ToastService.showToast(AppStrings.loginSuccessToast);

        if (context.mounted) {
          await _navigationService.handleAuthenticatedNavigation(context, user);
        }
      } on CustomException catch (ce) {
        ToastService.showToast(ce.toString(), type: ToastificationType.error);
      } catch (e) {
        ToastService.showToast(AppStrings.loginFailedToast,
            type: ToastificationType.error);
      }
      LoadingScreen.instance().hide();
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.appTitle,
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  form,
                  const SizedBox(height: 40),
                  actionButton,
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.onSurface,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          AppStrings.orLoginText,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.onSurface,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => signInWithGoogle(context),
                      child: Image.asset(
                        'assets/icons/googleIcon.png',
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
