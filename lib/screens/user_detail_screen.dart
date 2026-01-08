import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserDetailScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  //local copy of data
  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  Future<void> _deleteUser() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete User?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(widget.user.id).delete();
        if(!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User deleted")));
      } catch (e) {
        if(!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  void _editUser() {
    final nameController = TextEditingController(text: _currentUser.name);
    final emailController = TextEditingController(text: _currentUser.email);
    final ageController = TextEditingController(text: _currentUser.age.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit User"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () async {
              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim())) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid email address")));
                return;
              }

              int? age = int.tryParse(ageController.text.trim());
              if(age == null || age <= 0 || age > 120) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid age")));
                return;
              }
              try {
                // Update Firestore
                UserModel updatedUser = UserModel(
                  id: _currentUser.id,
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  age: age,
                );

                await FirebaseFirestore.instance.collection('users').doc(_currentUser.id).update(updatedUser.toMap());

                // Update local state
                setState(() {
                  _currentUser = updatedUser;
                });

                if(!mounted) return;
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User updated")));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentUser.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editUser,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteUser,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    child: Text(
                      _currentUser.name.isNotEmpty ? _currentUser.name[0].toUpperCase() : '?',
                      style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                _buildDetailRow("Full Name", _currentUser.name, Icons.person),
                const Divider(),
                _buildDetailRow("Email", _currentUser.email, Icons.email),
                const Divider(),
                _buildDetailRow("Age", _currentUser.age.toString(), Icons.cake),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 5),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}