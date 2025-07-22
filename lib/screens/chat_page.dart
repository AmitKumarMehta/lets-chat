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

  void _onMessageTap(DocumentSnapshot msgDoc) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Choose Action'),
      content: const Text('Do you want to update or delete this message?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close current dialog
            _showUpdateDialog(msgDoc); // Show update dialog
          },
          child: const Text('Edit'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close current dialog
            _confirmDeleteMessage(msgDoc); // Confirm delete
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

void _confirmDeleteMessage(DocumentSnapshot msgDoc) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Message'),
      content: const Text('Are you sure you want to delete this message?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            await msgDoc.reference.delete();
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}


  void _showUpdateDialog(DocumentSnapshot msgDoc) {
  final TextEditingController updateController =
      TextEditingController(text: msgDoc['text']);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Message'),
      content: TextField(
        controller: updateController,
        decoration: const InputDecoration(hintText: 'Enter new message'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final newText = updateController.text.trim();
            if (newText.isNotEmpty) {
              await msgDoc.reference.update({'text': newText});
              Navigator.pop(context);
            }
          },
          child: const Text('Edit'),
        ),
      ],
    ),
  );
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

                      return GestureDetector(
                        onTap: () => _onMessageTap(msg),
                        child: Container(
                          alignment:
                              isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isMe ? Colors.blue[300] : Colors.green[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              msg['text'],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      );
                      // Container(
                      //   alignment:
                      //       isMe ? Alignment.centerRight : Alignment.centerLeft,
                      //   padding: const EdgeInsets.all(8),
                      //   child: Container(
                      //     padding: const EdgeInsets.all(12),
                      //     decoration: BoxDecoration(
                      //       color: isMe ? Colors.blue[300] : Colors.green[300],
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Text(
                      //       msg['text'],
                      //       style: TextStyle(fontSize: 20),
                      //     ),
                      //   ),
                      // );
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
