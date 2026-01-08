import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').orderBy('created_at', descending: true).snapshots(),
      builder: (context, snapshot) {

        //Handle Errors
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        //Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        //Get data
        final data = snapshot.requireData;

        if (data.size == 0) {
          return const Center(child: Text("No users found. Add one!"));
        }

        //List
        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) {
            var doc = data.docs[index];
            
            // Convert to Model
            UserModel user = UserModel.fromMap(
              doc.data() as Map<String, dynamic>, 
              doc.id
            );

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(user.email),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(
                        user: user,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}