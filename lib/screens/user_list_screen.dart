import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/chat_screen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final currentUser = auth.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text("Users")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final users = snapshot.data!.docs
              .where((doc) => doc['uid'] != currentUser.uid)
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['email']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        receiverId: user['uid'],
                        receiverEmail: user['email'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
