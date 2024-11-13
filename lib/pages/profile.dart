import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_stash/constants/strings.dart';
import 'package:my_stash/pages/login.dart';
import 'package:my_stash/providers/passwords_provider.dart';
import 'package:my_stash/providers/theme_provider.dart';
import 'package:my_stash/providers/user_provider.dart';
import 'package:my_stash/services/auth_service.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:my_stash/widgets/loading_screen_controller.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

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
                    child: ClipOval(
                      // This will clip the content to a circular shape
                      child: userProvider.user?.photoUrl != null
                          ? Image(
                              fit: BoxFit
                                  .cover, // BoxFit.cover ensures the image covers the area
                              image: NetworkImage(
                                  '${userProvider.user?.photoUrl}'),
                              width:
                                  100, // Make sure image dimensions match container
                              height: 100,
                            )
                          : const Icon(
                              Icons.person,
                              size: 90,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    userProvider.user?.displayName ??
                        AppStrings.username.toUpperCase(),
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
                          AppStrings.account,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                        const Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          final themeProvider =
                              Provider.of<ThemeProvider>(context);
                          final currentTheme = themeProvider.themeMode;

                          return CupertinoActionSheet(
                            title: const Text(AppStrings.chooseTheme),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                isDefaultAction:
                                    currentTheme == ThemeMode.system,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.systemDefault,
                                      style: TextStyle(
                                        color: currentTheme == ThemeMode.system
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                      ),
                                    ),
                                    if (currentTheme == ThemeMode.system)
                                      const SizedBox(width: 8),
                                    if (currentTheme == ThemeMode.system)
                                      Icon(
                                        CupertinoIcons.checkmark_circle_fill,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20,
                                      ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .setTheme(ThemeMode.system);
                                },
                              ),
                              CupertinoActionSheetAction(
                                isDefaultAction:
                                    currentTheme == ThemeMode.light,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.light,
                                      style: TextStyle(
                                        color: currentTheme == ThemeMode.light
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                      ),
                                    ),
                                    if (currentTheme == ThemeMode.light)
                                      const SizedBox(width: 8),
                                    if (currentTheme == ThemeMode.light)
                                      Icon(
                                        CupertinoIcons.checkmark_circle_fill,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20,
                                      ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .setTheme(ThemeMode.light);
                                },
                              ),
                              CupertinoActionSheetAction(
                                isDefaultAction: currentTheme == ThemeMode.dark,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.dark,
                                      style: TextStyle(
                                        color: currentTheme == ThemeMode.dark
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                      ),
                                    ),
                                    if (currentTheme == ThemeMode.dark)
                                      const SizedBox(width: 8),
                                    if (currentTheme == ThemeMode.dark)
                                      Icon(
                                        CupertinoIcons.checkmark_circle_fill,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20,
                                      ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .setTheme(ThemeMode.dark);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    },
                    child: Container(
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
                            AppStrings.theme,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                          const Icon(Icons.chevron_right)
                        ],
                      ),
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
                          AppStrings.notification,
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
                LoadingScreen.instance().show(context: context);
                try {
                  await _googleAuthService.singOut(context);
                  ToastService.showToast(AppStrings.successLogOut);
                  if (context.mounted) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                  userProvider.clearUser();
                  passwordProvider.clearAll();
                } catch (e) {
                  ToastService.showToast(e.toString(),
                      type: ToastificationType.error);
                }
                LoadingScreen.instance().hide();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size.fromHeight(40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: const Text(
                AppStrings.logout,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
