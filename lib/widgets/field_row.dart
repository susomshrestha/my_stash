import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_stash/providers/user_provider.dart';
import 'package:my_stash/services/crypto_service.dart';
import 'package:my_stash/services/key_service.dart';
import 'package:provider/provider.dart';

class FieldRow extends StatefulWidget {
  final String label;
  final String value;
  final bool isHidden;

  const FieldRow(
      {super.key,
      required this.label,
      required this.value,
      this.isHidden = false});

  @override
  State<FieldRow> createState() => _FieldRowState();
}

class _FieldRowState extends State<FieldRow> {
  bool showField = false;
  String decryptedValue = '';
  final CryptoService _cryptoService = CryptoService();
  final KeyService _keyService = KeyService();

  // handle decryption
  Future<String> getDecryptedValue() async {
    // Only decrypt if we haven't already
    if (decryptedValue.isEmpty) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final key =
          await _keyService.getKeyFromSecureStorage(userProvider.user!.id);
      if (key != null) {
        decryptedValue = await _cryptoService.decrypt(
            widget.value, Uint8List.fromList(base64Decode(key)));
      }
    }
    return decryptedValue;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSecondary),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              (widget.isHidden && !showField)
                  ? '*****'
                  : (showField ? decryptedValue : widget.value),
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ],
        ),
        Row(
          children: [
            if (widget.isHidden) ...[
              IconButton(
                icon: Icon(showField
                    ? Icons.visibility_off
                    : Icons.remove_red_eye_outlined),
                onPressed: () async {
                  if (!showField) {
                    await getDecryptedValue();
                    setState(() {
                      showField = true;
                    });
                  } else {
                    setState(() {
                      showField = false;
                    });
                  }
                },
              ),
            ],
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () async {
                if (widget.isHidden) {
                  final value = await getDecryptedValue();
                  await Clipboard.setData(ClipboardData(text: value));
                } else {
                  await Clipboard.setData(ClipboardData(text: widget.value));
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
