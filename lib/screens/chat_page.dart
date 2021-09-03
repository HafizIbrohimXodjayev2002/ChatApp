import 'package:chatapp/constants/chat_page_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseAuth _authUser = FirebaseAuth.instance;
  User? user;
  TextEditingController _messageController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void userOlibKel() async {
    try {
      final hozirgiUser = await _authUser.currentUser;
      if (hozirgiUser != null) {
        user = hozirgiUser;
      }
    } catch (e) {
      print("CHAT PAGE GET DATA ERROR: " + e.toString());
    }
  }

  void messageOlibKel() async {
    var a = await _firestore.collection('messages').get();
    for (var item in a.docs) {
      print(item.data());
    }
  }

  void messageStreamOlibKel() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var item in snapshot.docs) {
        print("STREAM: " + item.data().toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    messageStreamOlibKel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        actions: [
          IconButton(
            onPressed: () async {
              await _authUser.signOut();
              Navigator.pushReplacementNamed(
                context,
                'kirish_ekran',
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Chat",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('uploadTime')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
                final messages = snapshot.data!.docs.reversed;
                List<BubbleMessage> messagelarWidget = [];
                for (var message in messages) {
                  final messageText = message['message'];
                  final emailText = message['email'];

                  final messageWidget = BubbleMessage(
                      messageText, emailText, _authUser.currentUser);
                  messagelarWidget.add(messageWidget);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.all(10),
                    children: messagelarWidget,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onChanged: (v) {},
                      decoration: kMessageSendTextFieldStyle,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _firestore.collection('messages').add({
                        'message': _messageController.text,
                        'email': _authUser.currentUser!.email.toString(),
                        'uploadTime': DateTime.now(),
                      });
                      _messageController.clear();
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleMessage extends StatelessWidget {
  String message;
  String email;
  var userEmail;
  BubbleMessage(this.message, this.email, this.userEmail);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "$email",
            style: TextStyle(
              color: Colors.deepOrange,
            ),
            textAlign: userEmail.email.toString() == email.toString()
                ? TextAlign.right
                : TextAlign.left,
          ),
          Align(
            alignment: userEmail.email.toString() == email.toString()
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Material(
              color: Colors.indigo,
              borderRadius: userEmail.email.toString() == email.toString()
                  ? kOngTomon
                  : kChapTomon,
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Text(
                  "$message",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
