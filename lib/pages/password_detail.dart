import 'package:flutter/material.dart';
import 'package:my_stash/widgets/field_row.dart';

class PasswordDetailPage extends StatelessWidget {
  final String title;

  const PasswordDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(5)),
                child: const Column(
                  children: [
                    FieldRow(
                        label: 'USERNAME / EMAIL', value: "teset@test.com"),
                    SizedBox(
                      height: 20,
                    ),
                    FieldRow(
                      label: 'PASSWORD',
                      value: "*********",
                      isPassword: true,
                    ),
                  ],
                ),
              ),
            ],
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
