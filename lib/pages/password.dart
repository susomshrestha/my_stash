import 'package:flutter/material.dart';
import 'package:my_stash/widgets/password_list_item.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool _isSearching = false; // State to track if the search is active
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> passwordList = [
    {
      'title': 'Gmail',
    },
    {
      'title': 'Facebook',
    },
  ];

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Search bar in the AppBar
        title: _buildSearchBar(),
        toolbarHeight: 80,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // Height of the border
          child: Container(
            height: 2.0, // Height of the border line
            color: Theme.of(context).colorScheme.surface, // Color of the border line
          ),
        ),
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
                  return PasswordListItem(title: password['title']!);
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
