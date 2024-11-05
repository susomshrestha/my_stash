import 'package:flutter/material.dart';
import 'package:my_stash/models/password_model.dart';
import 'package:my_stash/widgets/field_row.dart';

class PasswordDetailPage extends StatelessWidget {
  final PasswordModel password;

  const PasswordDetailPage({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    List<Widget> buildExtraFields() {
      return password.extra.map((extraField) {
        return Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: FieldRow(
            label: extraField.question,
            value: extraField.answer,
            isHidden: true,
          ),
        );
      }).toList(); // Convert the iterable to a list
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
                Text(
                  password.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
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
                onPressed: () {},
                shape: const CircleBorder(),
                backgroundColor: Theme.of(context).colorScheme.error,
                child: const Icon(Icons.delete),
              ),
              const SizedBox(
                width: 40,
              ),
              FloatingActionButton(
                onPressed: () {},
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
