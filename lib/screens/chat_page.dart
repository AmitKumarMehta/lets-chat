import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/screens/receiver_page.dart';
import 'package:lets_chat/theme/gradient_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverEmail;
  final String receiverName;

  const ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverEmail,
    required this.receiverName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  String getChatId() {
    return currentUser.uid.hashCode <= widget.receiverId.hashCode
        ? '${currentUser.uid}_${widget.receiverId}'
        : '${widget.receiverId}_${currentUser.uid}';
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId())
        .collection('messages')
        .add({
          'senderId': currentUser.uid,
          'text': messageController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatId = getChatId();
    final gradientProvider = Provider.of<GradientProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ReceiverPage(
                      receiverUid: widget.receiverId,
                      receiverName: widget.receiverName,
                      receiverEmail: widget.receiverEmail,
                    ),
              ),
            );
          },
          child: Text(
            widget.receiverName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor:
            gradientProvider.isSwitched ? Color(0xFF5DE0E6) : Color(0xFF87CEEB),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient:
              gradientProvider.isSwitched
                  ? gradientProvider.gradient2
                  : gradientProvider.gradient1,
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .collection('messages')
                        .orderBy('timestamp')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator());
                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['senderId'] == currentUser.uid;

                      return Container(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[300] : Colors.green[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            msg['text'],
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 25, left: 7, right: 5),

              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 242, 10, 10),
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(
                          Icons.message_rounded,
                          size: 23,
                          color:
                              gradientProvider.isSwitched
                                  ? Color.fromARGB(255, 7, 237, 237)
                                  : const Color.fromARGB(255, 0, 0, 0),
                        ),
                        hintText: 'Enter Message',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color:
                              gradientProvider.isSwitched
                                  ? Color.fromARGB(255, 7, 237, 237)
                                  : const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: Icon(
                      Icons.send_rounded,
                      size: 35,
                      color:
                          gradientProvider.isSwitched
                              ? const Color.fromARGB(255, 7, 237, 237)
                              : Color.fromARGB(255, 6, 124, 67),
                    ),
                  ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: TextField(
            //         controller: messageController,
            //         decoration: const InputDecoration(
            //           hintText: 'Enter message...',
            //         ),
            //       ),
            //     ),
            //     IconButton(
            //       icon: const Icon(Icons.send),
            //       onPressed: sendMessage,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
