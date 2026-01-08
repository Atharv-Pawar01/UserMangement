import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserScreen extends StatefulWidget {
  final String userId;
  final String currentName;
  final String currentEmail;
  final int currentAge;

  const EditUserScreen({
    super.key,
    required this.userId,
    required this.currentName,
    required this.currentEmail,
    required this.currentAge,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _ageController = TextEditingController(text: widget.currentAge.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> updateUser() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fields cannot be empty")));
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'age': int.parse(_ageController.text.trim()),
      });

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Updated!")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            const SizedBox(height: 10),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 10),
            TextField(controller: _ageController, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: updateUser, child: const Text("Update User")),
          ],
        ),
      ),
    );
  }
}