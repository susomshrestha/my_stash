import 'package:flutter/material.dart';
import 'package:my_stash/pages/password.dart';
import 'package:my_stash/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> _bodyOptions = <Widget>[
    const PasswordPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                offset: const Offset(0, -2), // Shadow position
                blurRadius: 6, // Shadow blur
              ),
            ],
          ),
          child: Material(
            color: Theme.of(context).colorScheme.primary,
            child: NavigationBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onDestinationSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              selectedIndex: selectedIndex,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.password),
                  label: 'Passwords',
                  selectedIcon: Icon(Icons.password,
                      color: Theme.of(context)
                          .colorScheme
                          .primary), // Selected icon color
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_off_outlined),
                  label: 'Profile',
                  selectedIcon: Icon(Icons.person_off_outlined,
                      color: Theme.of(context)
                          .colorScheme
                          .primary), // Selected icon color
                ),
              ],
              indicatorColor: Theme.of(context)
                  .scaffoldBackgroundColor, // Indicator color for selected tab
            ),
          ),
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: _bodyOptions,
        ),
      ),
    );
  }
}
