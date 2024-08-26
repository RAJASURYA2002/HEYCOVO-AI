import 'package:alarm/alarm.dart';

import 'package:hive/hive.dart';

late AlarmSettings alarmSettings;
late DateTime alarmTime;
final localData = Hive.box('userdata');
Future<void> setalarm(DateTime dateTime) async {
  alarmSettings = AlarmSettings(
    id: 42,
    dateTime: dateTime,
    assetAudioPath: localData.get("Alarm"),
    loopAudio: localData.get("LOOP"),
    vibrate: localData.get("Vibrate"),
    volume: localData.get("Sound"),
    fadeDuration: 3.0,
    notificationTitle: 'Wake-UP Time☝️',
    notificationBody:
        'Start your day with a smile – stop the alarm and embrace the possibilities ahead!...\nEase into your morning by silencing the alarm and stepping into a world of endless opportunities and vibrant possibilities.',
    enableNotificationOnKill: true,
    androidFullScreenIntent: true,
  );
  await Alarm.set(alarmSettings: alarmSettings);
  // print(localData.get("Alarm"));
}

Future<void> alarmStop() async {
  await Alarm.stop(42);
  localData.put("timeDifference", '0');
}
