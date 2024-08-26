import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/alarm/alarmfunction.dart';
import 'package:heyconvo/page/chat_Screen/chat_network.dart';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

final _firestore = FirebaseFirestore.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? loggedInUser;
TextEditingController textEditingController = TextEditingController();
/////////////////----Function----//////////////////
int color(String color) {
  int indexToRemove = 0;
  String colorValue =
      color.substring(0, indexToRemove) + color.substring(indexToRemove + 1);
  colorValue = "0xff$colorValue";
  return int.parse(colorValue);
}

/////////////////----Function----//////////////////
/////////////////----CircleIcon----//////////////////
class CircleIcon extends StatelessWidget {
  const CircleIcon(
      {super.key,
      this.backgroundColor,
      this.iconData,
      this.radius,
      this.iconColor,
      this.iconSize});
  final String? backgroundColor;
  final IconData? iconData;
  final double? radius;
  final String? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Color(color(backgroundColor!)),
      radius: radius!,
      child: Icon(
        iconData,
        size: iconSize,
        color: Color(color(iconColor!)),
      ),
    );
  }
}

/////////////////----CircleIcon----//////////////////
/////////////////----CircleImage----//////////////////
class CircleImage extends StatelessWidget {
  const CircleImage(
      {super.key,
      this.imagePath,
      this.radius,
      this.borderColor,
      this.borderWidth});
  final String? imagePath;
  final double? radius;
  final String? borderColor;
  final double? borderWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(color(borderColor!)), // Set the border color here
          width: borderWidth!, // Set the border width here
        ),
      ),
      child: CircleAvatar(
        backgroundImage: AssetImage(imagePath!),
        radius: radius,
      ),
    );
  }
}

/////////////////----CircleImage----//////////////////
/////////////////----TODO----//////////////////
class TaskSlider extends StatelessWidget {
  const TaskSlider(
      {super.key,
      this.count,
      this.taskName,
      this.description,
      this.startDate,
      this.endDate,
      this.onTap});
  final int? count;
  final String? taskName;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xff121b22),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Ktext(
                text: "#$count",
                fontSize: 35,
                color: "#e6ebef",
                fontFamily: "Roboto",
                fontWeight: FontWeight.w900,
              ),
              Ktext(
                text: taskName,
                fontSize: taskName!.length > 10 ? 20 : 30,
                color: "#fcfdff",
                fontFamily: "Roboto",
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
          Ktext(
            text: description,
            fontSize: 14,
            color: "#fcfdff",
            fontFamily: "Roboto",
            fontWeight: FontWeight.w900,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onTap,
                child: const Icon(
                  Icons.pending,
                  size: 50,
                  color: Colors.red,
                ),
              ),
              Container(
                width: 180,
                height: 30,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff222831), width: 5),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Marquee(
                  text:
                      'Start Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(startDate!)} ▶️ End Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(endDate!)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12),
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20.0,
                  velocity: 50.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 15.0,
                  accelerationDuration: const Duration(seconds: 1),
                  accelerationCurve: Curves.linear,
                  decelerationDuration: const Duration(milliseconds: 500),
                  decelerationCurve: Curves.easeOut,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/////////////////----TODO----//////////////////
/////////////////----Weather----//////////////////
class Weather extends StatelessWidget {
  const Weather(
      {super.key,
      this.iconData,
      this.iconColor,
      this.weatherType,
      this.degree,
      this.place,
      this.weatherColor,
      this.textColor,
      this.wind,
      this.humidity,
      this.pressure});
  final IconData? iconData;
  final Color? iconColor;
  final Color? weatherColor;
  final String? textColor;
  final String? weatherType;
  final String? degree;
  final String? place;
  final double? wind;
  final int? humidity;
  final int? pressure;
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: weatherColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      iconData,
                      size: 70,
                      color: iconColor,
                    ),
                    Column(
                      children: [
                        Ktext(
                          text: weatherType,
                          color: textColor,
                          fontFamily: "Poppins",
                          fontSize: weatherType!.length > 10 ? 15 : 20,
                          fontWeight: FontWeight.w900,
                        ),
                        Ktext(
                          text: "$degree°",
                          color: textColor,
                          fontFamily: "Poppins",
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    Ktext(
                      text: place,
                      color: textColor,
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Color(0xff121b22),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WeatherDetail(
                      type: "Wind",
                      value: "$wind mph",
                    ),
                    WeatherDetail(
                      type: "Humidity",
                      value: "$humidity%",
                    ),
                    WeatherDetail(
                      type: "Pressure",
                      value: "$pressure mb",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  const WeatherDetail({super.key, this.type, this.value});
  final String? type;
  final String? value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Ktext(
          text: type,
          color: "#e6ebef",
          fontFamily: "Poppins",
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        Ktext(
          text: value,
          color: "#e6ebef",
          fontFamily: "Poppins",
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ],
    );
  }
}

/////////////////----Weather----//////////////////
////////////////----Friends/Group----///////////////////
class Friends extends StatelessWidget {
  const Friends({super.key, this.name, this.id, this.profileName, this.icon});
  final String? name;
  final String? id;
  final String? profileName;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              WordsProfile(
                firstLetter: profileName!.substring(0, 1).toUpperCase(),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Ktext(
                    text: name,
                    color: "#e6ebef",
                    fontFamily: "Poppins",
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                  Ktext(
                    text: id,
                    color: "#86949b",
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Ktext(
                text: "Today",
                color: "#86949b",
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              Icon(
                // profileName == "HeyConvo AI" ? Icons.voice_chat : Icons.chat,
                icon,
                color: const Color(0xff86949b),
              ),
            ],
          )
        ],
      ),
    );
  }
}

////////////////----Friends/Groups----///////////////////
///////////////////----ADD WIDGETS----///////////////////
class AddFrients extends StatefulWidget {
  const AddFrients({super.key});

  @override
  State<AddFrients> createState() => _AddFrientsState();
}

class _AddFrientsState extends State<AddFrients> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  // var userId;
  var currentFriendList = [];
  var bestFriendList = [];
  var bestFrientName = "";
  String loggedInUserDocId = "";
  String friendUserDocId = "";
  String loggedInUserDocRef = '';
  int bestFrientID = 0;
  int id = 0;
  bool loading = true;
  final localData = Hive.box('userdata');
  late QuerySnapshot<Map<String, dynamic>> meassage;
  void getData() async {
    meassage = await _firestore.collection("UserData").get();
    for (var message in meassage.docs) {
      var email = message["e-mail"];
      if (email == localData.get("Email")) {
        currentFriendList = message["friends"];
        loggedInUserDocId = message.id;
        setState(() {});
        return;
      }
    }
  }

  bool check(int id) {
    if (id != localData.get("ID")) {
      for (var friendid in currentFriendList) {
        if (friendid["id"] == id) {
          return false;
        }
      }
    } else {
      return false;
    }
    return true;
  }

  void addFriends(int enterid) async {
    setState(() {
      loading = false;
    });
    int check = 0;
    if (meassage.docs.isNotEmpty) {
      for (var id in meassage.docs) {
        var entireID = id["messageid"];
        if (enterid == entireID) {
          bestFriendList = id["friends"];
          bestFrientID = id["messageid"];
          bestFrientName = id["userName"];
          friendUserDocId = id.id;
          check = 1;
        }
      }
    } else {
      kerror("Server Bussy");
    }
    if (check == 1) {
      if (loggedInUserDocId != "" && friendUserDocId != "") {
        currentFriendList.add({"name": bestFrientName, "id": bestFrientID});
        bestFriendList
            .add({"name": localData.get("User"), "id": localData.get("ID")});
        try {
          DocumentReference currentUser =
              firestore.collection('UserData').doc(loggedInUserDocId);
          DocumentReference friend =
              firestore.collection('UserData').doc(friendUserDocId);
          await currentUser.update({
            'friends': currentFriendList,
          });
          await friend.update({
            'friends': bestFriendList,
          });
          firestore.collection("MessageFriend").add({
            "chatId0": localData.get("ID"),
            "chatId1": bestFrientID,
            "messageBox": [],
          });
          ksuccess("Friend add successfully 👍");
        } catch (e) {
          kerror("'Error updating field: $e'");
        }
      } else {
        kerror("Server Bussy");
      }
    } else {
      kerror("No friends found 😔");
    }
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Container(
              height: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 10, 50, 10),
              child: Column(
                children: [
                  TextFiledHome(
                    text: "Enter Friend ID",
                    maxLength: 7,
                    keyboardType: TextInputType.number,
                    icon: Icons.account_box,
                    onchanged: (value) {
                      if (value != "") {
                        id = int.parse(value);
                      }
                    },
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      if (id.toString().length == 7) {
                        if (check(id)) {
                          addFriends(id);
                          textEditingController.clear();
                        } else {
                          kwarning(
                              "User Already your friend!\n check your Friend list");
                        }
                        textEditingController.clear();
                        FocusScope.of(context).unfocus();
                      } else {
                        kerror("ID Must contain 7 Number\n Try again!..");
                      }
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Ktext(
                    text:
                        "If you encounter any issues while Adding Friends,please send an message to Heyconvo Team ✅",
                    color: "#FF204E",
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
  }
}

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String groupName = "";
  int groupid = 0;
  List messageID = [];
  String groupRef = "";
  Random random = Random();
  final localData = Hive.box('userdata');
  bool loading = true;

  Future<int> getData() async {
    final meassage = await _firestore.collection("MessageGroup").get();
    int id = random.nextInt(9000) + 1000;
    for (var message in meassage.docs) {
      var messageid = message["groupid"];
      if (messageid == id) {
        id = random.nextInt(9000) + 1000;
      }
    }
    return id;
  }

  void createGroup(String groupName) async {
    setState(() {
      loading = false;
    });
    int id = await getData();
    if (groupName != "") {
      _firestore.collection("MessageGroup").add({
        'groupid': id,
        'groupname': groupName,
        'users': [
          {"name": localData.get("User"), "id": localData.get("ID")}
        ],
        'messageBox': [
          {
            "name": "HeyConvo Team 2024",
            "text":
                "Welcome to HeyConvo! We're thrilled to have you here. Our platform is designed for collaborative learning, where you can connect with others who share your interests. If you have any questions or need assistance, feel free to reach out to us at heyconvo2024@gmail.com. Happy learning!"
          }
        ]
      });
      ksuccess("Group created successful");
    } else {
      kerror("groupName does not exit!...");
    }
    setState(() {
      loading = true;
    });
  }

  void joinGroup(int id) async {
    messageID = [];
    setState(() {
      loading = false;
    });
    final meassage = await _firestore.collection("MessageGroup").get();
    for (var message in meassage.docs) {
      if (message["groupid"] == id) {
        messageID = message["users"];
        groupRef = message.id;
        break;
      }
    }
    if (messageID.contains(localData.get("ID"))) {
      kwarning("Already you join in this group");
    } else {
      try {
        messageID
            .add({"name": localData.get("User"), "id": localData.get("ID")});
        DocumentReference currentUser =
            firestore.collection('MessageGroup').doc(groupRef);
        await currentUser.update({
          'users': messageID,
        });
        ksuccess("You have add in the Group 👍");
      } catch (e) {
        kerror("No such group found😔\n$e");
        groupid = 0;
      }
    }
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Container(
              height: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 10, 50, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFiledHome(
                      text: "Enter Group Name",
                      maxLength: 20,
                      keyboardType: TextInputType.name,
                      icon: Icons.badge,
                      onchanged: (value) {
                        if (value != "") {
                          groupName = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (groupName != "") {
                          createGroup(groupName);
                          textEditingController.clear();
                          FocusScope.of(context).unfocus();
                        } else {
                          kwarning("Group must conatain name🅰️");
                        }
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFiledHome(
                        maxLength: 4,
                        text: "Join Group",
                        icon: Icons.diversity_3,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onchanged: (value) {
                          if (value != "") {
                            groupid = int.parse(value);
                          }
                        }),
                    const SizedBox(
                      height: 7,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (groupid.toString().length == 4) {
                          joinGroup(groupid);
                          textEditingController.clear();
                          FocusScope.of(context).unfocus();
                        } else {
                          kerror("Group ID Must contain four numbers 4️⃣");
                        }
                      },
                      child: const Icon(
                        Icons.group_add,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Ktext(
                      text:
                          "If you encounter any issues while creating the group, please send an message to Heyconvo Team ✅",
                      color: "#FF204E",
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
  }
}

///////////////TESTING////////////////
class CreateChannel extends StatefulWidget {
  const CreateChannel({super.key});

  @override
  State<CreateChannel> createState() => _CreateChannelState();
}

class _CreateChannelState extends State<CreateChannel> {
  bool loading = true;
  String channelName = "";
  String description = "";
  @override
  Widget build(BuildContext context) {
    return loading
        ? Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Container(
              height: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 10, 50, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFiledHome(
                      text: "Enter Channel Name",
                      maxLength: 20,
                      keyboardType: TextInputType.name,
                      icon: Icons.badge,
                      onchanged: (value) {
                        channelName = value;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFiledHome(
                        text: "Channel description",
                        icon: Icons.diversity_3,
                        keyboardType: TextInputType.name,
                        onchanged: (value) {
                          description = value;
                        }),
                    const SizedBox(
                      height: 30,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (channelName != "" && description != "") {
                          _firestore.collection("Global_chat").add({
                            "GroupName": channelName,
                            "GroupOwner": localData.get("User"),
                            "MessageBox": [
                              {
                                "Name": localData.get("User"),
                                "Time":
                                    "$channelName by ${localData.get("User")}",
                                "text": description
                              }
                            ]
                          });
                          ksuccess("Channel Create");
                          textEditingController.clear();
                          FocusScope.of(context).unfocus();
                        } else {
                          kerror("Check all box");
                        }
                      },
                      child: const Icon(
                        Icons.group_add,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Ktext(
                      text:
                          "If you encounter any issues while creating the Channel, please send an message to Heyconvo Team ✅",
                      color: "#FF204E",
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
  }
}

///////////////TESTING////////////////
class TextFiledHome extends StatelessWidget {
  const TextFiledHome(
      {super.key,
      this.text,
      this.maxLength,
      this.keyboardType,
      this.icon,
      this.onchanged});
  final String? text;
  final int? maxLength;
  final TextInputType? keyboardType;
  final IconData? icon;
  final void Function(String)? onchanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: maxLength,
      keyboardType: keyboardType,
      obscureText: false,
      onChanged: onchanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        fillColor: Colors.white,
        labelText: text, // Changed from 'label' to 'labelText'
        suffixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        // errorText: error,
      ),
    );
  }
}

///////////////////----ADD WIDGETS----///////////////////
//////////////////Global Chat////////////////
//////////////////Global Chat////////////////
IconData kweathericondata(int temp) {
  if (temp < 0) {
    return Icons.severe_cold;
  } else if (temp == 0) {
    return Icons.sync;
  } else if (temp >= 10 && temp < 20) {
    return Icons.cloudy_snowing;
  } else if (temp >= 20 && temp < 25) {
    return Icons.sunny_snowing;
  } else if (temp >= 25 && temp < 30) {
    return Icons.wb_sunny_outlined;
  } else if (temp >= 30 && temp < 35) {
    return Icons.sunny;
  } else {
    return Icons.sunny;
  }
}

Color kweatherColor(int temp) {
  if (temp == 0) {
    return const Color(0xffFF204E);
  } else if (temp >= 25) {
    return const Color(0xffffe697);
  } else if (temp >= 20 && temp < 25) {
    return const Color(0xffd4e2e8);
  } else {
    return const Color(0xffb2e9ff);
  }
}

Color kiconColor(int temp) {
  if (temp == 0) {
    return const Color(0xff222831);
  } else if (temp >= 25) {
    return const Color(0xffffc100);
  } else if (temp >= 20 && temp < 25) {
    return const Color(0xffa4bdc8);
  } else {
    return const Color(0xff50d3fc);
  }
}

String ktextColor(int temp) {
  if (temp == 0) {
    return "#222831";
  } else if (temp >= 25) {
    return "#a37e10";
  } else if (temp >= 20 && temp < 25) {
    return "#a6b5bb";
  } else {
    return "#0f76a3";
  }
}
