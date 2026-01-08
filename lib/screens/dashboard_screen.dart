import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'add_user_screen.dart';
import 'user_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const UserListScreen(), //0: List
    const AddUserScreen(),  //1: Add
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              icon: const Icon(Icons.logout, size: 20),
              label: const Text("Logout"),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                AuthService().logout();
              },
            ),
          )
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "View Data"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Data"),
        ],
      ),
    );
  }
}