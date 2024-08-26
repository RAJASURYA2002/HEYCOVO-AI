import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/chat_Screen/chat_network.dart';
import 'package:hive/hive.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;

class ChatFrient extends StatefulWidget {
  static const String id = "chatfriend";
  const ChatFrient({super.key, this.userid, this.user});
  final String? user;
  final int? userid;

  @override
  State<ChatFrient> createState() => _ChatFrientState();
}

class _ChatFrientState extends State<ChatFrient> {
  final localData = Hive.box('userdata');
  bool isLoaderVisible = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late DateTime now;
  late int month;
  late int day;
  late int year;
  late int hour;
  late int minute;
  late String amPm;
  @override
  void initState() {
    super.initState();
    getMessageBox(
      widget.userid!,
      localData.get("ID"),
    );
    now = DateTime.now();
    month = now.month;
    day = now.day;
    year = now.year;
    hour = now.hour > 12
        ? now.hour - 12
        : now.hour; // Convert 24-hour format to 12-hour format
    minute = now.minute;
    amPm = now.hour >= 12 ? 'PM' : 'AM';
  }

  var messageBox = [];
  String messageBoxId = "";
  void getMessageBox(int chatId0, int chatId1) async {
    setState(() {
      isLoaderVisible = false;
    });
    var messages = await _firestore.collection("MessageFriend").get();
    for (var message in messages.docs) {
      if (chatId0 == message["chatId0"] && chatId1 == message["chatId1"] ||
          chatId1 == message["chatId0"] && chatId0 == message["chatId1"]) {
        messageBox = message["messageBox"];
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
    // String formattedDate = DateFormat('dd/MM/YY').format(now);
    String formattedTime = DateFormat('h:mm a').format(now);
    String dayOfWeek = DateFormat('EEEE').format(now);
    return isLoaderVisible
        ? Scaffold(
            backgroundColor: const Color(0xff000000),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xff19191a),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      WordsProfile(
                        firstLetter: widget.user!.substring(0, 1).toUpperCase(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Ktext(
                            text: widget.user!,
                            color: "#c9d3d1",
                            fontFamily: "Poppins",
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                          Ktext(
                            text: "${widget.userid!}",
                            color: "#c9d3d1",
                            fontFamily: "Poppins",
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                        ],
                      )
                    ],
                  ),
                  const Icon(
                    Icons.volume_off,
                    color: Colors.white,
                  ),
                  const Icon(
                    Icons.block,
                    color: Colors.white,
                  ),
                  const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            body: Column(
              children: [
                DateChip(
                  date: DateTime(year, month, day),
                  color: const Color(0x558AD3D5),
                ),
                Expanded(
                  child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xff0c0c0c),
                      ),
                      child: MessageStream(
                        chatId0: widget.userid!,
                        chatId1: localData.get("ID"),
                      )),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xff191919),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: MessageBar(
                      messageBarHintStyle: const TextStyle(color: Colors.black),
                      messageBarColor: const Color(0xff191919),
                      onSend: (value) async {
                        messageBox.add({
                          "id": localData.get("ID"),
                          "text": value,
                          "time": "$formattedTime $dayOfWeek"
                        });
                        DocumentReference currentUser = firestore
                            .collection('MessageFriend')
                            .doc(messageBoxId);
                        await currentUser.update({
                          'messageBox': messageBox,
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
  }
}