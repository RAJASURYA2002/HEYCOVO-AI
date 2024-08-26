import 'dart:io';

import 'package:heyconvo/Network/weather/gitrequest.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/alarm/alarmfunction.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

final localData = Hive.box('userdata');

Future<String> replay(String speech) async {
  speech = speech.toLowerCase();
  // print(speech);
  GitRequest gitSpeech = GitRequest();
  var speechJson = await gitSpeech.getSpeech();
  //open document
  if (speech.contains("open")) {
    if (speech.contains(" ")) {
      var check = speech.split(" ");
      File file = File("/storage/emulated/0/Download/heyconvo/${check[1]}.pdf");
      if (file.existsSync()) {
        return file.path;
      } else {
        return "Hello there! How can I assist you today?";
      }
    } else {
      File file = File("/storage/emulated/0/Download/heyconvo/$speech.pdf");
      if (file.existsSync()) {
        return file.path;
      } else {
        return "Hello there! How can I assist you today?";
      }
    }
  }
  //set alarm
  else if (speech.contains("set alarm on") || speech.contains("alarm on")) {
    return alarmfix(speech);
  }
  //check weather
  else if (speech.contains("what is the weather now") ||
      speech.contains("what is the weather")) {
    int temp = localData.get("Temp");
    if (temp > 0 && temp < 15) {
      return "Hey there!  Let me check the weather for you...\nIt's a bit chilly out there. How about staying cozy indoors? Maybe a movie marathon or a warm cup of cocoa?";
    } else {
      return "Hey there! Let me check the weather for you...\nIt's nice outside! Why not go for a walk or spend some time in the sun?";
    }
  } else {
    for (var answer in speechJson) {
      List question = answer["Question"];
      if (question.contains(speech)) {
        return answer["Answer"];
      }
    }
  }
  return "Hello there! How can I assist you today?";
}

String alarmfix(String speech) {
  // Extracting the time from the user input
  RegExp regExp = RegExp(r"(\d{1,2}):(\d{2}) ([ap]\.m\.)");
  Match? match = regExp.firstMatch(speech);

  if (match != null) {
    int hours = int.parse(match.group(1)!);
    int minutes = int.parse(match.group(2)!);
    String period = match.group(3)!;

    // Adjusting hours based on AM/PM
    if (period.toLowerCase() == 'p.m.') {
      hours = (hours + 12) % 24; // Convert to 24-hour format
    }

    // Creating the DateTime object
    DateTime alarmDateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hours, minutes);
    // Check if the specified time has already passed for today
    if (alarmDateTime.isBefore(DateTime.now())) {
      // If the specified time has passed, set the alarm for the same time on the next day
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
    }
    // print(alarmDateTime);
    setalarm(alarmDateTime);
    ksuccess("Alarm set successfully\nAlarm set for: $alarmDateTime");
    localData.put("Switch", true);
    Duration difference = alarmDateTime.difference(DateTime.now());
    localData.put("timeDifference",
        '${difference.inHours} hr : ${difference.inMinutes} min');
    return 'Alarm set for: ${DateFormat('h:mm a').format(alarmDateTime)}';
  } else {
    return 'sorry! Try Again';
  }
}
