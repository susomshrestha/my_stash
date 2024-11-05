import 'package:flutter/material.dart';
import 'package:my_stash/models/password_model.dart';
import 'package:my_stash/pages/password_detail.dart';

class PasswordListItem extends StatelessWidget {
  final PasswordModel pwd;

  const PasswordListItem({
    super.key,
    required this.pwd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordDetailPage(password: pwd),
          ),
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Icon(
              Icons.accessibility,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            title: Text(
              pwd.title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
