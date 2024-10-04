import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPassword;

  const FieldRow(
      {super.key,
      required this.label,
      required this.value,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(value),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () async {
            await Clipboard.setData(const ClipboardData(text: "test@test.com"));
          },
        )
      ],
    );
  }
}
