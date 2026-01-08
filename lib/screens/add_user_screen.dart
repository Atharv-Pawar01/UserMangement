import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();

  bool isLoading = false;

  Future<void> addUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    int? age = int.tryParse(_ageController.text.trim());
    if(age == null || age <= 0 || age > 120) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid age")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      UserModel newUser = UserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        age: age,
      );

      await FirebaseFirestore.instance.collection('users').add(newUser.toMap());

      _nameController.clear();
      _emailController.clear();
      _ageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User Added Successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text("Add New User", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email Address", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _ageController,
            decoration: const InputDecoration(labelText: "Age", border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),

          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
            onPressed: addUser,
            child: const Text("Save User"),
          ),
        ],
      ),
    );
  }
}