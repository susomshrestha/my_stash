import 'package:flutter/material.dart';
import 'package:my_stash/models/password_model.dart';
import 'package:my_stash/models/user_model.dart';
import 'package:my_stash/pages/manage_password.dart';
import 'package:my_stash/providers/user_provider.dart';
import 'package:my_stash/services/password_service.dart';
import 'package:my_stash/services/toast_service.dart';
import 'package:my_stash/widgets/password_list_item.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool _isSearching = false; // State to track if the search is active
  final TextEditingController _searchController = TextEditingController();
  final PasswordService _passwordService = PasswordService();

  List<PasswordModel> passwordList = [];

  @override
  void initState() {
    super.initState();
    _fetchPasswords(); // Fetch passwords when the widget is initialized

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPasswords() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      UserModel? user = userProvider.user;
      List<PasswordModel> passwords =
          await _passwordService.getPasswordTitlesWithIds(user!.id);
      setState(() {
        passwordList = passwords; // Update the password list with fetched data
      });
      // ToastService.showToast("Loaded all passwords.", type: "success");
    } catch (e) {
      // Handle any errors here (e.g., show a message)
      ToastService.showToast("Failed to load passwords.", type: "error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Search bar in the AppBar
        title: _buildSearchBar(),
        toolbarHeight: 80,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0), // Height of the border
          child: Container(
            height: 2.0, // Height of the border line
            color: Theme.of(context)
                .colorScheme
                .surface, // Color of the border line
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManagePasswordPage()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: passwordList.length,
                itemBuilder: (context, index) {
                  final password = passwordList[index];
                  return PasswordListItem(pwd: password);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          // Search Input Field
          Expanded(
              child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.secondary,
              filled: true,
              hintText: 'Search by name...',
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
              prefixIcon: Icon(Icons.search,
                  color: Theme.of(context).colorScheme.onSecondary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0), // Rounded corners
                borderSide: BorderSide.none, // Borderless
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0), // Rounded corners
                borderSide: BorderSide.none, // No border on focus
              ),
            ),
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSecondary), // Set input text color to grey
            onTap: () {
              setState(() {
                _isSearching = true; // Activate the search bar
              });
            },
          )),

          // Cancel Button (shown only when search is active)
          if (_isSearching)
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onPressed: () {
                setState(() {
                  _isSearching = false; // Deactivate the search bar
                  _searchController.clear(); // Clear the search input
                });
                FocusScope.of(context).unfocus(); // Dismiss the keyboard
              },
            ),
        ],
      ),
    );
  }
}
