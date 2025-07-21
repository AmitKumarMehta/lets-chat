import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/screens/chat_page.dart';
import 'package:lets_chat/screens/profile.dart';
import 'package:lets_chat/screens/search.dart';
import 'package:lets_chat/theme/gradient_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final currentUser = FirebaseAuth.instance.currentUser;

  logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final gradientProvider = Provider.of<GradientProvider>(context); 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: gradientProvider.isSwitched ? Color.fromARGB(255, 234, 179, 131): Color(0xFF87CEEB),

        leading: Icon(Icons.home, size: 28),

        title: Text(
          'Lets Chat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Search()),
              );
            },
            icon: Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            icon: Icon(Icons.person, color: Colors.black),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,

        decoration: BoxDecoration(
          gradient: gradientProvider.isSwitched?gradientProvider.gradient2:gradientProvider.gradient1,
          // gradient: LinearGradient(
          //   colors: [Color(0xFF87CEEB), Color(0xFF98FF98)], // Orange gradients
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            final users =
                snapshot.data!.docs
                    .where((doc) => doc['uid'] != currentUser!.uid)
                    .toList();

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(
                    user['name'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    user['email'],
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ChatPage(
                              receiverId: user['uid'],
                              receiverEmail: user['email'],
                              receiverName: user['name'],
                            ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
