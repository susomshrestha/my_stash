import 'package:flutter/material.dart';
import 'package:my_stash/pages/home.dart';
import 'package:my_stash/services/crypto_service.dart';
import 'package:my_stash/services/key_service.dart';
import 'package:my_stash/services/toast_service.dart';

class KeyInputPage extends StatefulWidget {
  final String userId;

  const KeyInputPage({
    super.key,
    required this.userId,
  });

  @override
  State<KeyInputPage> createState() => _KeyInputPageState();
}

class _KeyInputPageState extends State<KeyInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  final KeyService _keyService = KeyService();
  bool _isLoading = false;
  final CryptoService _cryptoService = CryptoService();

  Future<void> _saveKey() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {

      final key = _cryptoService.deriveKey(_keyController.text);

      await _keyService.saveKey(widget.userId, key);

      if (!mounted) return;

      ToastService.showToast(
        "Encryption key saved successfully",
        type: "success",
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ToastService.showToast(
        "Failed to save encryption key. Please try again.",
        type: "error",
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Encryption Key'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Please set your encryption key. This key will be used to encrypt and decrypt your data. Make sure to remember it!',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _keyController,
                decoration: const InputDecoration(
                  labelText: 'Encryption Key',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an encryption key';
                  }
                  if (value.length < 6) {
                    return 'Key must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveKey,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Key'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
