import 'dart:async';
import 'dart:core';
import 'package:alarm/alarm.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heyconvo/Network/weather/location.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/alarm/alarmfunction.dart';
import 'package:heyconvo/page/alarm/alarmstop.dart';
import 'package:heyconvo/page/chat_Screen/chat.dart';
import 'package:heyconvo/page/chat_Screen/chatfriend.dart';
import 'package:heyconvo/page/chat_Screen/chatgroup.dart';
import 'package:heyconvo/page/chat_Screen/global_chat.dart';
import 'package:heyconvo/page/home/widget.dart';
import 'package:heyconvo/page/quick_Document/quick.dart';
import 'package:heyconvo/page/view_account/account.dart';
import 'package:heyconvo/page/view_account/widget_account.dart';
import 'package:heyconvo/page/widget_app/widget_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;
const _kPages = <String, IconData>{
  'Home': Icons.home,
  'Message': Icons.message,
  'HeyConvo': Icons.mic,
  'Add': Icons.add,
  'Public': Icons.public,
};

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = "home_page";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current = 0;
  // final CarouselController _controller = CarouselController();
  DateTime now = DateTime.now();
  final localData = Hive.box('userdata');
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  TabStyle tabStyle = TabStyle.flip;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String timeDifference = '0 min';
  // bool _switchVal = false;
  bool isLoaderVisible = true;
  bool entirePageLoader = true;
  TextEditingController textEditingController = TextEditingController();
  static StreamSubscription<AlarmSettings>? subscription;
  List<Widget> container = [];
  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    localData.get("repeat") ? getCurrentUser() : false;
    // getCurrentUser();
    const duration = Duration(seconds: 1);
    Timer(duration, () {
      getLocalValue();
    });
    weatherData();
    listFriends();
    showtask();
    globalFriends();
  }
  ///////////////////////////

  void showtask() {
    int i = 1;
    container = [];
    List getTask = [];
    getTask = localData.get("TaskName") ?? [];

    for (var task in getTask) {
      container.add(TaskSlider(
        count: i++,
        taskName: task["name"],
        description: task["description"],
        startDate: task["startDate"],
        endDate: task["endDate"],
        onTap: () {
          setState(() {
            showtask();
          });
        },
      ));
    }
    if (container.isEmpty) {
      container.add(
        GestureDetector(
          onTap: () {
            setState(() {
              showtask();
            });
          },
          child: const Center(
            child: Text(
              "No Task Found😀",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
    }
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AlarmStop(),
      ),
    );
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
  //////////////////////////

  String user = "";
  void getLocalValue() {
    setState(() {
      user = localData.get("User");
    });
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        getData(loggedInUser!.email);
      }
    } catch (e) {
      // print(e);
    }
  }

  void getData(String? loggedInUser) async {
    localData.put("User", "");
    final meassage = await _firestore.collection("UserData").get();
    for (var message in meassage.docs) {
      var email = message["e-mail"];
      if (email == loggedInUser) {
        localData.put("User", message["userName"]);
        localData.put("Email", message["e-mail"]);
        localData.put("Headline", message["headline"]);
        localData.put("ID", message["messageid"]);
        localData.put("MobileNumber", message["mobileNumber"]);
        localData.put("Friends", message["friends"]);
        localData.put("Alarm", "assets/alarm_1.mp3");
        localData.put("Sound", 0.5);
        localData.put("Notification", true);
        localData.put("Vibrate", false);
        localData.put("LOOP", true);
        localData.put("Switch", false);
        localData.put("repeat", false);
      }
    }
  }

  List<Widget> friendList = [];
  List<Widget> globalList = [];
  void listFriends() async {
    friendList = [];
    setState(() {
      isLoaderVisible = false;
    });
    final meassage = await _firestore.collection("UserData").get();
    final groups = await _firestore.collection("MessageGroup").get();
    String email = localData.get("Email");
    // String id = localData.get("ID");
    friendList.add(
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ),
          );
        },
        child: const Friends(
          name: "Invictus AI",
          id: "Chat with AI",
          profileName: "Invictus AI",
          icon: Icons.voice_chat,
        ),
      ),
    );
    for (var message in meassage.docs) {
      if (email == message["e-mail"]) {
        List friendsid = message["friends"];
        for (var friend in friendsid) {
          friendList.add(
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatFrient(
                      user: friend["name"],
                      userid: friend["id"],
                    ),
                  ),
                );
              },
              child: Friends(
                name: friend["name"],
                id: friend["id"].toString(),
                profileName: friend["name"],
                icon: Icons.chat,
              ),
            ),
          );
        }
        for (var group in groups.docs) {
          var groupids = group["users"];
          for (var groupid in groupids) {
            if (groupid["id"] == localData.get("ID")) {
              friendList.add(
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatGroup(
                          groupName: group["groupname"],
                          groupId: group["groupid"],
                          name: group["users"],
                        ),
                      ),
                    );
                  },
                  child: Friends(
                    name: group["groupname"],
                    id: group["groupid"].toString(),
                    profileName: "G",
                    icon: Icons.groups,
                  ),
                ),
              );
            }
          }
        }
        setState(() {
          isLoaderVisible = true;
        });
      }
    }
  }

//////////////////////////////////////
  void globalFriends() async {
    globalList = [];
    setState(() {
      isLoaderVisible = false;
    });

    final groups = await _firestore.collection("Global_chat").get();
    for (var group in groups.docs) {
      globalList.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GlobalChat(
                  groupName: group["GroupName"],
                ),
              ),
            );
          },
          child: Friends(
            name: group["GroupName"],
            id: "Chat with Global Friends",
            profileName: "P",
            icon: Icons.public,
          ),
        ),
      );
      setState(() {
        isLoaderVisible = true;
      });
    }
  }

/////////////////////////////////////
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        // Get the current date and time
        final DateTime now = DateTime.now();
        // Combine the current date and the selected time
        DateTime selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
        setalarm(selectedDateTime);
        ksuccess("Alarm set successfully\nAlarm set for: $selectedDateTime");
        _calculateTimeDifference();
      });
    } else {
      alarmStop();
      ksuccess("Alarm Stoped!...");
      localData.put("timeDifference", '0');
      setState(() {
        // _switchVal = false;
      });
    }
  }

  void _calculateTimeDifference() {
    final now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Check if the selected time is earlier than the current time
    if (selectedDateTime.isBefore(now)) {
      // Add one day to the selectedDateTime
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }

    final difference = selectedDateTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    setState(() {
      timeDifference = '$hours hr : $minutes min';
      localData.put("timeDifference", '$hours hr : $minutes min');
    });
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod;
    final minute = '${timeOfDay.minute}'.padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  final PanelController _panelController = PanelController();

  double _panelHeightOpen = 500;
  Widget panel = const AddFrients();

  //featch weather Data//
  String iconname = "";
  int temp = 0;
  String place = "Error";
  double wind = 0;
  int humidity = 0;
  int pressure = 0;

  Future<void> weatherData() async {
    var weatherData = await WeatherModel().getLocationWeather();
    if (weatherData != null) {
      iconname = weatherData["weather"][0]["description"];
      temp = weatherData["main"]["temp"].toDouble().toInt();
      localData.put("Temp", temp);
      place = weatherData["name"];
      wind = weatherData["wind"]["speed"].toDouble();
      humidity = weatherData["main"]["humidity"].toInt();
      pressure = weatherData["main"]["pressure"].toInt();
    } else {
      iconname = "Error";
      temp = 0;
      place = "Error";
      wind = 0;
      humidity = 0;
      pressure = 0;
    }
    setState(() {});
  }

  // final flutterWebviewPlugin = FlutterWebviewPlugin();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavBar(user: user),
                const SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: TabBarView(
                    children: [
                      /////////////////----HOME----//////////////////
                      Column(
                        children: [
                          CarouselSlider(
                            items: container,
                            // carouselController: _controller,
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                aspectRatio: 2.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    current = index;
                                  });
                                }),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color(0xff121b22),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Ktext(
                                      text: _formatTimeOfDay(selectedTime),
                                      color: "#e6ebef",
                                      fontFamily: "Poppins",
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    Switch(
                                      value: localData.get("Switch"),
                                      onChanged: (bool value) {
                                        if (value == false) {
                                          alarmStop();
                                        }
                                        setState(() {
                                          if (value) {
                                            _selectTime(context);
                                            localData.put("Switch", value);
                                          } else {
                                            localData.put(
                                                "timeDifference", '0');
                                          }
                                          // _switchVal = value;
                                        });
                                        localData.put("Switch", value);
                                      },
                                    )
                                  ],
                                ),
                                Container(
                                    padding: const EdgeInsets.all(8),
                                    width: double.infinity,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: Color(0xff121b22),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Ktext(
                                          text:
                                              "Date : ${now.day}/${now.month}/${now.year}",
                                          color: "#b5bffd",
                                          fontFamily: "Poppins",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                        Ktext(
                                          text:
                                              'sleep : ${localData.get("timeDifference")}',
                                          color: "#b5bffd",
                                          fontFamily: "Poppins",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Weather(
                            iconData: kweathericondata(temp),
                            iconColor: kiconColor(temp),
                            weatherColor: kweatherColor(temp),
                            weatherType: iconname,
                            degree: "$temp",
                            place: place,
                            textColor: ktextColor(temp),
                            wind: wind,
                            humidity: humidity,
                            pressure: pressure,
                          ),
                        ],
                      ),
                      /////////////////----HOME----//////////////////
                      /////////////////----Message----///////////////
                      isLoaderVisible
                          ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    listFriends();
                                  },
                                  child: Container(
                                    color: const Color(0xff121b22),
                                    child: const Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: friendList,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const Center(
                              child:
                                  CircularProgressIndicator(), // Loading indicator
                            ),
                      /////////////////----Message----///////////////
                      /////////////////----AI-Message----///////////////
                      const QuickDocument(),
                      /////////////////----AI-Message----///////////////
                      /////////////////----Add----///////////////
                      Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                              ),
                              child: SlidingUpPanel(
                                color: const Color(0xffFFF7FC),
                                maxHeight: _panelHeightOpen,
                                minHeight: 0,
                                controller: _panelController,
                                panel: panel,
                                body: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SettingBox(
                                        icon1: Icons.person_add,
                                        icon2: Icons.add_circle,
                                        text: "Add Friend's",
                                        fontsize: 20,
                                        onTap: () {
                                          _panelController.open();
                                          setState(() {
                                            panel = const AddFrients();
                                            _panelHeightOpen = 300;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      SettingBox(
                                        icon1: Icons.group,
                                        icon2: Icons.add_circle,
                                        text: "Create Group & Join Group",
                                        fontsize: 18,
                                        onTap: () {
                                          _panelController.open();
                                          setState(() {
                                            panel = const CreateGroup();
                                            _panelHeightOpen = 700;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      SettingBox(
                                        icon1: Icons.public,
                                        icon2: Icons.add_circle,
                                        text: "Create Public Channel",
                                        fontsize: 16,
                                        onTap: () {
                                          _panelController.open();
                                          setState(() {
                                            panel = const CreateChannel();
                                            _panelHeightOpen = 700;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      SettingBox(
                                        icon1: Icons.bug_report,
                                        icon2: Icons.add_circle,
                                        text: "Bug Report",
                                        fontsize: 20,
                                        onTap: () {
                                          _panelController.open();
                                          setState(() {
                                            panel = const CreateChannel();
                                            _panelHeightOpen = 700;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      /////////////////----Add----///////////////
                      /////////////////----Public----///////////////
                      isLoaderVisible
                          ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    globalFriends();
                                  },
                                  child: const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: globalList,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const Center(
                              child:
                                  CircularProgressIndicator(), // Loading indicator
                            ),
                      /////////////////----Public----///////////////
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: ConvexAppBar(
            onTap: (index) {
              if (index == 0) {
                // initState();
                setState(() {});
              }
            },
            curveSize: 0,
            backgroundColor: Colors.black,
            style: tabStyle,
            items: <TabItem>[
              for (final entry in _kPages.entries)
                TabItem(icon: entry.value, title: entry.key),
            ],
          ),
        ),
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({
    super.key,
    required this.user,
  });

  final String user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ViewAccount.id);
              },
              child: const CircleImage(
                imagePath: "images/home/boy.png",
                radius: 25,
                borderColor: "#effded",
                borderWidth: 3,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ktext(
                  text: 'HI,$user!',
                  color: "#ffffff",
                  fontSize: 14,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w900,
                ),
                const Ktext(
                  text: "Good to see you again",
                  color: "#ffffff",
                  fontSize: 14,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w100,
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, WidgetScreen.id);
          },
          child: const CircleIcon(
            backgroundColor: "#effded",
            iconData: Icons.widgets,
            radius: 22,
            iconColor: "#0F0F0F",
          ),
        ),
      ],
    );
  }
}
