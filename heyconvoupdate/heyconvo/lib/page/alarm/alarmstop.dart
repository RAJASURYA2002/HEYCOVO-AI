import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:heyconvo/constant.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class AlarmStop extends StatefulWidget {
  static const String id = "AlarmStop";
  const AlarmStop({super.key});

  @override
  State<AlarmStop> createState() => _AlarmStopState();
}

DateTime now = DateTime.now();

class _AlarmStopState extends State<AlarmStop> {
  String formattedDate = DateFormat('dd/MM/yyyy').format(now);
  String formattedTime = DateFormat('h:mm a').format(now); // 'a' for AM/PM
  String dayOfWeek = DateFormat('EEEE').format(now);
  final localData = Hive.box('userdata');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onVerticalDragDown: (details) {
          kwarning("Swipe from bottom or click up arrow button to stop");
        },
        child: Scaffold(
          backgroundColor: const Color(0xff26343d),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xff26343d),
                  border: Border.all(color: const Color(0xff26343d), width: 5),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ktext(
                      text: formattedTime,
                      color: "#EEEEEE",
                      fontFamily: "Roboto",
                      fontSize: 70,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.center,
                    ),
                    Ktext(
                      text: "$formattedDate $dayOfWeek",
                      color: "#EEEEEE",
                      fontFamily: "Roboto",
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Ktext(
                text:
                    "Start your day with a smile – stop the alarm and embrace the possibilities ahead!...\nEase into your morning by silencing the alarm and stepping into a world of endless opportunities and vibrant possibilities.",
                color: "#EEEEEE",
                fontFamily: "Roboto",
                fontSize: 15,
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.center,
              ),
              const Ktext(
                text: "HeyConvo AI Alarm",
                color: "#EEEEEE",
                fontFamily: "Roboto",
                fontSize: 15,
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.center,
              ),
              const Ktext(
                text: "Swipe up to stop",
                color: "#EEEEEE",
                fontFamily: "Roboto",
                fontSize: 15,
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onVerticalDragDown: (details) async {
                  await Alarm.stop(42);
                  localData.put("Switch", false);
                  SystemNavigator.pop();
                },
                child: const Icon(
                  Icons.expand_less,
                  color: Color(0xffEEEEEE),
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
