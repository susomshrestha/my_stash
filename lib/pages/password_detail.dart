import 'package:flutter/material.dart';
import 'package:my_stash/models/password_model.dart';
import 'package:my_stash/pages/manage_password.dart';
import 'package:my_stash/providers/passwords_provider.dart';
import 'package:my_stash/providers/user_provider.dart';
import 'package:my_stash/services/password_service.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:my_stash/widgets/field_row.dart';
import 'package:provider/provider.dart';

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
      }).toList(); // Convert the iterable to a list
    }

    void deletePassword() async {
      try {
        await _passwordService.deletePassword(
            userProvider.user!.id, password.id!);
        if (context.mounted) {
          Navigator.pop(context, 'OK');
          Navigator.pop(context);
        }
        passwordProvider.deletePassword(password.id!);
        ToastService.showToast("Successfully delete password", type: "success");
      } catch (e) {
        ToastService.showToast("Failed to delete Password", type: "error");
      }
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
                              fontSize: 30, fontWeight: FontWeight.bold),
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
                          icon: const Icon(Icons.edit_square))
                    ]),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldRow(label: 'USERNAME', value: password.username),
                      const SizedBox(
                        height: 20,
                      ),
                      FieldRow(label: 'EMAIL', value: password.username),
                      const SizedBox(
                        height: 20,
                      ),
                      const FieldRow(
                        label: 'PASSWORD',
                        value: "*********",
                        isHidden: true,
                      ),
                      const SizedBox(height: 20),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: deletePasswordConfirmation,
                heroTag: 'deleteTag',
                shape: const CircleBorder(),
                backgroundColor: Theme.of(context).colorScheme.error,
                child: const Icon(Icons.delete),
              ),
              const SizedBox(
                width: 40,
              ),
              FloatingActionButton(
                onPressed: () {},
                heroTag: 'showTag',
                shape: const CircleBorder(),
                child: const Icon(Icons.remove_red_eye),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
