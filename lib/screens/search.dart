import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/screens/chat_page.dart';
import 'package:lets_chat/theme/gradient_provider.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> searchResults = [];

  void searchUsers(String email) async {
    if (email.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    final result =
        await firestore
            .collection('users')
            .where('email', isGreaterThanOrEqualTo: email)
            .where('email', isLessThan: email + 'z')
            .get();

    // filter out current user
    final filtered =
        result.docs.where((doc) => doc['uid'] != auth!.uid).toList();
    setState(() {
      searchResults = filtered;
    });
  }

  void navigateToChat(DocumentSnapshot userDoc) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => ChatPage(
              receiverId: userDoc['uid'],
              receiverEmail: userDoc['email'],
              receiverName: userDoc['name'],
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradientProvider = Provider.of<GradientProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            gradientProvider.isSwitched
                ? Color(0xFF5DE0E6)
                : Color(0xFF87CEEB),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Search...',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient:
              gradientProvider.isSwitched
                  ? gradientProvider.gradient2
                  : gradientProvider.gradient1,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: searchUsers,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.5,
                            color:  Color.fromARGB(255, 242, 10, 10),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 3.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Search user email..',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final user = searchResults[index];
                  return GestureDetector(
                    onTap: () => navigateToChat(user),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          225,
                          230,
                          235,
                        ).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            user['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
