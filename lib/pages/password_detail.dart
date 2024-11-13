import 'package:flutter/material.dart';
import 'package:my_stash/models/password_model.dart';
import 'package:my_stash/pages/manage_password.dart';
import 'package:my_stash/providers/passwords_provider.dart';
import 'package:my_stash/providers/user_provider.dart';
import 'package:my_stash/services/password_service.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:my_stash/widgets/field_row.dart';
import 'package:my_stash/widgets/loading_screen_controller.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class PasswordDetailPage extends StatelessWidget {
  const PasswordDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordProvider =
        Provider.of<PasswordsProvider>(context, listen: true);
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    final _passwordService = PasswordService();

    PasswordModel password = passwordProvider.password!;

    List<Widget> buildExtraFields() {
      return password.extra.map((extraField) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FieldRow(
            label: extraField.question,
            value: extraField.answer,
            isHidden: true,
          ),
        );
      }).toList();
    }

    void deletePassword() async {
      LoadingScreen.instance().show(context: context);
      try {
        await _passwordService.deletePassword(
            userProvider.user!.id, password.id!);
        if (context.mounted) {
          Navigator.pop(context, 'OK');
          Navigator.pop(context);
        }
        passwordProvider.deletePassword(password.id!);
        ToastService.showToast("Successfully delete password");
      } catch (e) {
        ToastService.showToast("Failed to delete Password",
            type: ToastificationType.error);
      }
      LoadingScreen.instance().hide();
    }

    void deletePasswordConfirmation() {
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to continue?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: deletePassword,
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        password.title.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 30,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagePasswordPage(
                              password: password,
                            ),
                          ),
                        )
                      },
                      icon: Icon(
                        Icons.edit_square,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (password.username.isNotEmpty) ...[
                        FieldRow(label: 'USERNAME', value: password.username),
                        const SizedBox(height: 20),
                      ],
                      FieldRow(label: 'EMAIL', value: password.email),
                      const SizedBox(height: 20),
                      FieldRow(
                        label: 'PASSWORD',
                        value: password.password,
                        isHidden: true,
                      ),
                      const SizedBox(height: 20),
                      if (password.extra.isNotEmpty) ...[
                        Text(
                          'Extra',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...buildExtraFields(),
                      ]
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: deletePasswordConfirmation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    icon: const Icon(Icons.delete),
                    label: const Text(
                      'Delete Password',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
