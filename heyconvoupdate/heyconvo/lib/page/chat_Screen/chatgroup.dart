import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/chat_Screen/chat_network.dart';
import 'package:heyconvo/page/home/widget.dart';
import 'package:hive/hive.dart';
import 'package:marquee/marquee.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

final _firestore = FirebaseFirestore.instance;

class ChatGroup extends StatefulWidget {
  static const String id = "chatgroup";
  const ChatGroup({super.key, this.groupName, this.groupId, this.name});
  final String? groupName;
  final int? groupId;
  final List? name;

  @override
  State<ChatGroup> createState() => _ChatGroupState();
}

class _ChatGroupState extends State<ChatGroup> {
  @override
  void initState() {
    super.initState();
    getData();
    getMessageBox();
  }

  String marquee = "";
  bool isLoaderVisible = true;
  var messagegroup = [];
  String messageBoxId = "";
  final localData = Hive.box('userdata');
  void getData() {
    if (widget.name != null) {
      if (widget.name is Iterable) {
        for (var name in widget.name!) {
          marquee += '${name["name"]},  '.toUpperCase();
        }
      } else {
        kerror("Server bussy");
      }
    }
    setState(() {});
  }

  void getMessageBox() async {
    setState(() {
      isLoaderVisible = false;
    });
    var messages = await _firestore.collection("MessageGroup").get();
    for (var message in messages.docs) {
      if (message["groupid"] == widget.groupId) {
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
                      const WordsProfile(
                        firstLetter: "G",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Ktext(
                            text: widget.groupName,
                            color: "#c9d3d1",
                            fontFamily: "Poppins",
                            fontSize: widget.groupName!.length > 15 ? 13 : 17,
                            fontWeight: FontWeight.w900,
                          ),
                          Ktext(
                            text: "${widget.groupId}",
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
                Container(
                  width: double.infinity,
                  height: 30,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xff222831), width: 5),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Marquee(
                    text: 'Group Members are ($marquee)',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 20.0,
                    velocity: 100.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10.0,
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xff0c0c0c),
                    ),
                    child: MessageGroup(
                      id: widget.groupId,
                    ),
                  ),
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
                        messagegroup.add(
                            {"name": localData.get("User"), "text": value});
                        DocumentReference currentUser = firestore
                            .collection('MessageGroup')
                            .doc(messageBoxId);
                        await currentUser.update({
                          'messageBox': messagegroup,
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
