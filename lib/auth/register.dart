import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/auth/login.dart';
import 'package:lets_chat/screens/home.dart';



class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController cpwController = TextEditingController();

  Future createUserWithEmail() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = pwController.text.trim();
    String cpass = cpwController.text.trim();
    try {
      if (password == cpass) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        User? user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
                'uid': user.uid,
                'name': name,
                'email': email,
                'createdAt': FieldValue.serverTimestamp(),
              });
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Passwords do not match",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? "An error occurred",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),

          // gradient: LinearGradient(
          //   colors: [Color(0xFF87CEEB), Color(0xFF98FF98)],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 180),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Lets Chat',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset('assets/chat.png', width: 150, height: 150),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Lets Chat',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign Up to the application',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 14, 10, 4),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, size: 30),
                      border: InputBorder.none,
                      hintText: "Enter Name",
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 14, 10, 4),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email, size: 30),
                      border: InputBorder.none,
                      hintText: "Enter Email",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 14, 10, 4),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: pwController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, size: 30),
                      border: InputBorder.none,
                      hintText: "Enter Password",
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 14, 10, 4),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: cpwController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, size: 30),
                      border: InputBorder.none,
                      hintText: "Confirm Password",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  color: Colors.transparent,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 232, 221, 16),
                    ),
                    onPressed: createUserWithEmail,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: const Text(
                        "Sign In Now",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
