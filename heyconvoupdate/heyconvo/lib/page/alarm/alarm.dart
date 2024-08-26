import 'package:flutter/material.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/home/widget.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AlarmSet extends StatefulWidget {
  static const String id = "alarm";
  const AlarmSet({super.key});
  @override
  State<AlarmSet> createState() => _AlarmSetState();
}

class _AlarmSetState extends State<AlarmSet> {
  DateTime now = DateTime.now();
  bool isMuted = false;
  final localData = Hive.box('userdata');
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    String formattedTime = DateFormat('h:mm a').format(now); // 'a' for AM/PM
    String dayOfWeek = DateFormat('EEEE').format(now);
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color(0xff121b22),
          body: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    CircleImage(
                      imagePath: "images/widget_icon/alarm.png",
                      radius: 30,
                      borderColor: "#5755FE",
                      borderWidth: 3,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Ktext(
                          text: "Alarm Setting",
                          color: "#3086ff",
                          fontFamily: "Roboto",
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                        Ktext(
                          text: "V 1.1.1",
                          color: "#8B93FF",
                          fontFamily: "Roboto",
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xff31363F),
                    border:
                        Border.all(color: const Color(0xff222831), width: 5),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Ktext(
                        text: formattedTime,
                        color: "#EEEEEE",
                        fontFamily: "Roboto",
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        textAlign: TextAlign.center,
                      ),
                      Ktext(
                        text: "$formattedDate $dayOfWeek",
                        color: "#EEEEEE",
                        fontFamily: "Roboto",
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(23),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Alarmset(
                            value: localData.get("LOOP"),
                            taskname: "Loop alarm audio",
                            onChanged: (value) {
                              setState(() {
                                localData.put("LOOP", value);
                              });
                            },
                          ),
                          Alarmset(
                            value: localData.get("Vibrate"),
                            taskname: "Vibrate",
                            onChanged: (value) {
                              setState(() {
                                localData.put("Vibrate", value);
                              });
                            },
                          ),
                          const DropDown(
                            taskname: "Sound",
                          ),
                          Alarmset(
                            value: localData.get("Notification"),
                            taskname: "Notification",
                            onChanged: (value) {
                              setState(() {
                                localData.put("Notification", value);
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              isMuted
                                  ? const Icon(
                                      Icons.volume_off,
                                      color: Color(0xffEEEEEE),
                                    )
                                  : const Icon(Icons.volume_up,
                                      color: Color(0xffEEEEEE)),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.white,
                                  thumbColor: const Color(0xffeb1555),
                                  overlayColor: const Color(0x29eb1555),
                                  inactiveTrackColor: const Color(0xff8d8e98),
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 15.0),
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 30.0),
                                ),
                                child: Slider(
                                  value: localData.get("Sound") * 100,
                                  min: 0,
                                  max: 100,
                                  divisions: 10,
                                  label:
                                      '${localData.get("Sound").toStringAsFixed(2)}',
                                  onChanged: (double value) {
                                    setState(() {
                                      localData.put("Sound", value / 100);
                                      if (value == 0) {
                                        isMuted = true;
                                      } else {
                                        isMuted = false;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                )
              ],
            ),
          )),
    );
  }
}

class Alarmset extends StatelessWidget {
  const Alarmset({super.key, this.taskname, this.onChanged, this.value});
  final String? taskname;
  final void Function(bool)? onChanged;
  final bool? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Ktext(
          text: taskname,
          color: "#EEEEEE",
          fontFamily: "Poppins",
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        Switch(
          value: value!,
          onChanged: onChanged,
        )
      ],
    );
  }
}

class DropDown extends StatefulWidget {
  const DropDown({super.key, this.taskname});
  final String? taskname;

  @override
  State<DropDown> createState() => _DropDownState();
}

final localData = Hive.box('userdata');

class _DropDownState extends State<DropDown> {
  String selectedValue = localData.get("Alarm") == "assets/alarm_1.mp3"
      ? "society of the snow"
      : "Default Sound";
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Ktext(
          text: widget.taskname,
          color: "#EEEEEE",
          fontFamily: "Poppins",
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        DropdownButton<String>(
          dropdownColor: const Color(0xff31363F),
          value: selectedValue,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
              if (newValue == "society of the snow") {
                localData.put("Alarm", "assets/alarm_1.mp3");
              } else {
                localData.put("Alarm", "assets/alarm_2.mp3");
              }
            });
          },
          items: <String>[
            'Default Sound',
            'society of the snow',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Ktext(
                text: value,
                color: "#EEEEEE",
                fontFamily: "Poppins",
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
