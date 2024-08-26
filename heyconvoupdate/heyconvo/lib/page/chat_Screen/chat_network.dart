import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heyconvo/constant.dart';
import 'package:hive/hive.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class WordsProfile extends StatelessWidget {
  const WordsProfile({
    super.key,
    this.firstLetter,
  });
  final String? firstLetter;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: const Color(0xff836FFF),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xff222831), width: 4.0)),
      child: Center(
        child: Text(
          firstLetter!,
          style: const TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, this.text, this.isMe, this.time});
  final String? text;
  final bool? isMe;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: isMe!
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
            elevation: 5.0,
            color: isMe! ? Colors.lightBlueAccent : const Color(0xff31363F),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: SelectableText(
                '$text',
                style: TextStyle(
                  color: isMe! ? Colors.black : Colors.white,
                  fontSize: 17.0,
                ),
              ),
            ),
          ),
          Ktext(
            text: time,
            color: "#c9d3d1",
            fontFamily: "Poppins",
            fontSize: 10,
            fontWeight: FontWeight.w100,
          ),
        ],
      ),
    );
  }
}

class MessageStream extends StatefulWidget {
  const MessageStream({super.key, this.chatId0, this.chatId1});
  final int? chatId0;
  final int? chatId1;

  @override
  State<MessageStream> createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List messageBox = [];
  String messageBoxId = "";
  List<MessageBubble> messageWidgets = [];
  final localData = Hive.box('userdata');
  bool isLoaderVisible = true;
  late DateTime now;

  @override
  void initState() {
    super.initState();
    getMessageBox();
  }

  void getMessageBox() async {
    setState(() {
      isLoaderVisible = false;
    });
    var messages = await _firestore.collection("MessageFriend").get();
    for (var message in messages.docs) {
      if (widget.chatId0 == message["chatId0"] &&
              widget.chatId1 == message["chatId1"] ||
          widget.chatId1 == message["chatId0"] &&
              widget.chatId0 == message["chatId1"]) {
        messageBox = message["messageBox"];
        messageBoxId = message.id;
        setState(() {
          isLoaderVisible = true;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoaderVisible
        ? StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection("MessageFriend")
                .doc(messageBoxId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var documentData =
                    snapshot.data!.data() as Map<String, dynamic>?;
                if (documentData != null) {
                  messageWidgets = [];

                  for (var add in documentData["messageBox"]) {
                    messageWidgets.add(MessageBubble(
                      text: add["text"],
                      isMe: localData.get("ID") == add["id"],
                      time: add["time"],
                    ));
                  }
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        children: messageWidgets.reversed.toList(),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
            })
        : const Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
  }
}

class MessageGroup extends StatefulWidget {
  const MessageGroup({super.key, this.id});
  final int? id;

  @override
  State<MessageGroup> createState() => _MessageGroupState();
}

class _MessageGroupState extends State<MessageGroup> {
  bool isLoaderVisible = true;
  List messagegroup = [];
  String messageBoxId = "";
  List<MessageBubble> messageWidgets = [];
  final localData = Hive.box('userdata');
  @override
  void initState() {
    super.initState();
    getMessageBox();
  }

  void getMessageBox() async {
    setState(() {
      isLoaderVisible = false;
    });
    var messages = await _firestore.collection("MessageGroup").get();
    for (var message in messages.docs) {
      if (message["groupid"] == widget.id) {
        messagegroup = message["messageBox"];
        messageBoxId = message.id;
        break;
      }
    }
    setState(() {
      isLoaderVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoaderVisible
        ? StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection("MessageGroup")
                .doc(messageBoxId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var documentData =
                    snapshot.data!.data() as Map<String, dynamic>?;
                if (documentData != null) {
                  messageWidgets = [];
                  for (var add in documentData["messageBox"]) {
                    messageWidgets.add(MessageBubble(
                      text: add["text"],
                      isMe: localData.get("User") == add["name"],
                      time: '${add["name"]} 12:00 AM',
                    ));
                  }
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        children: messageWidgets.reversed.toList(),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
            })
        : const Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
  }
}

class GlobalMessage extends StatefulWidget {
  const GlobalMessage({super.key, this.groupName});
  final String? groupName;

  @override
  State<GlobalMessage> createState() => _GlobalMessageState();
}

class _GlobalMessageState extends State<GlobalMessage> {
  bool isLoaderVisible = true;
  List messagegroup = [];
  String messageBoxId = "";
  String owner = "";
  List<MessageBubble> messageWidgets = [];
  @override
  void initState() {
    super.initState();
    getMessageBox();
  }

  void getMessageBox() async {
    setState(() {
      isLoaderVisible = false;
    });
    var messages = await _firestore.collection("Global_chat").get();
    for (var message in messages.docs) {
      if (message["GroupName"] == widget.groupName) {
        messagegroup = message["MessageBox"];
        messageBoxId = message.id;
        // owner = localData.get("User") == message["GroupOwner"];
        owner = message["GroupOwner"];
        break;
      }
    }
    setState(() {
      isLoaderVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoaderVisible
        ? StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection("Global_chat")
                .doc(messageBoxId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var documentData =
                    snapshot.data!.data() as Map<String, dynamic>?;
                if (documentData != null) {
                  messageWidgets = [];
                  for (var add in documentData["MessageBox"]) {
                    messageWidgets.add(MessageBubble(
                      text: add["text"],
                      isMe: owner == add["Name"] ? true : false,
                      time: add["Time"],
                    ));
                  }
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        children: messageWidgets.reversed.toList(),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
            })
        : const Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
  }
}
