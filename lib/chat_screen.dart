import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution_soul_interview_test/chat_model.dart';
import 'package:solution_soul_interview_test/firebase%20_and_firestore.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final FirebaseAndFirestore _firebaseAndFirestore = FirebaseAndFirestore();

  final _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Screen"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 600,
                child: StreamBuilder<List<ChatModel>?>(
                  stream: _firebaseAndFirestore.getMessages(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data == null) {
                      return const Center(
                        child: Text("No messages found"),
                      );
                    }
                    List<ChatModel>? chatList = snapshot.data;
                    String? uid = _firebaseAndFirestore.getUserId();
                    return ListView.builder(
                      itemCount: chatList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: uid == chatList[index].uid
                              ? Alignment.centerRight
                              : Alignment.centerRight,
                          color: uid == chatList[index].uid
                              ? const Color.fromARGB(255, 164, 196, 223)
                              : const Color.fromARGB(255, 17, 110, 185),
                          child: Text(chatList[index].message),
                        );
                      },
                    );
                  },
                ),
              ),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    SizedBox(
                      width: 280,
                      child: TextFormField(
                        controller: _messageController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Message is required";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () => sendMessage(),
                      icon: const Icon(
                        Icons.send,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void sendMessage() {
    FirebaseAndFirestore firebaseAndFirestore = FirebaseAndFirestore();
    User user = _firebaseAndFirestore.getUser();
    firebaseAndFirestore.sendMessage(
      ChatModel(
          email: user.email!,
          name: "Some name",
          uid: user.uid,
          message: _messageController.text,
          messageId: user.uid + _messageController.text),
    );
  }
}
