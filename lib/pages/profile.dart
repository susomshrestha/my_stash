import 'package:flutter/material.dart';
import 'package:my_stash/pages/login.dart';
import 'package:my_stash/providers/passwords_provider.dart';
import 'package:my_stash/providers/user_provider.dart';
import 'package:my_stash/services/auth_service.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final AuthService _googleAuthService = AuthService();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordProvider =
        Provider.of<PasswordsProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'USERNAME',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                        const Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dark Mode',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                        const Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notification',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                        const Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _googleAuthService.singOut(context);
                  ToastService.showToast("Successfully signed out.",
                      type: 'success');
                  if (context.mounted) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                  userProvider.clearUser();
                  passwordProvider.clearAll();
                } catch (e) {
                  ToastService.showToast(e.toString(), type: 'error');
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
