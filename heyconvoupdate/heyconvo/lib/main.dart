import 'dart:io';
import 'dart:convert';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/alarm/alarm.dart';
import 'package:heyconvo/page/alarm/alarmstop.dart';
import 'package:heyconvo/page/chat_Screen/chatfriend.dart';
import 'package:heyconvo/page/chat_Screen/chatgroup.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heyconvo/account/createaccount_screen.dart';
import 'package:heyconvo/account/login_screen.dart';
import 'package:heyconvo/intro/licence.dart';
import 'package:heyconvo/intro/terms_screen.dart';
import 'package:heyconvo/intro/welcome_screen.dart';
import 'package:heyconvo/page/chat_Screen/chat.dart';
import 'package:heyconvo/page/home/home_page.dart';
import 'package:heyconvo/page/view_account/account.dart';
import 'package:heyconvo/page/widget_app/widget_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';

//create folder for chatAI//
void createFolder() async {
  Directory? externalDir = await getExternalStorageDirectory();
  if (externalDir != null) {
    String newFolderName = 'Heyconvo';
    Directory newFolder = Directory('${externalDir.path}/$newFolderName');
    if (!(await newFolder.exists())) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat.yMMMMd().format(now);
      String formattedTime = DateFormat('h:mm a').format(now);
      newFolder.createSync();
      String newFilePath = '${newFolder.path}/ai_message_json.json';
      File newFile = File(newFilePath);
      List<Map<String, dynamic>> listOfMaps = [
        {
          'Input': 'Hi Invictus!...',
          'Output':
              '"Hello! I’m Invictus, here to provide you with accurate groundwater predictions and helpful insights for your area."',
          'Time': '$formattedDate $formattedTime'
        },
      ];
      String jsonString = jsonEncode(listOfMaps);
      newFile.writeAsStringSync(jsonString);
    } else {}
  } else {}
}

//permision//
void requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.storage,
    Permission.microphone,
    // Add more permissions as needed
  ].request();

  statuses.forEach((permission, status) {
    if (!status.isGranted) {
      // Handle the case when permission is not granted
      // For example, show a message or disable certain features
      kwarning("Permission Need!....");
    }
  });
}

Future<void> main() async {
  runApp(const LoadingScreen());
  WidgetsFlutterBinding.ensureInitialized();
  requestPermissions();
  await Hive.initFlutter();
  await Hive.openBox('userdata');
  await Alarm.init();
  final localData = Hive.box('userdata');
  if (localData.get("login") == null) {
    localData.put("login", false);
  }
  if (localData.get('repeat') == null) {
    localData.put("repeat", true);
    localData.put("Switch", false);
  }
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAgtfvbZbhll3nGHC1ukzMlNWpGuMcExck",
              appId: "1:920604788061:android:bf7f29f60007ca2afc54b4",
              messagingSenderId: "920604788061",
              projectId: "heyconvo-54857"),
        )
      : await Firebase.initializeApp();
  createFolder();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    final localData = Hive.box('userdata');
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          theme: ThemeData(useMaterial3: true),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
          initialRoute: localData.get('login') ? Home.id : WelcomeScreen.id,
          routes: {
            WelcomeScreen.id: (context) => const WelcomeScreen(),
            TermsScreen.id: (context) => const TermsScreen(),
            Licence.id: (context) => const Licence(),
            CreateAccount.id: (context) => const CreateAccount(),
            Login.id: (context) => const Login(),
            Home.id: (context) => const Home(),
            ViewAccount.id: (context) => const ViewAccount(),
            WidgetScreen.id: (context) => const WidgetScreen(),
            ChatScreen.id: (context) => const ChatScreen(),
            ChatFrient.id: (context) => const ChatFrient(),
            ChatGroup.id: (context) => const ChatGroup(),
            AlarmSet.id: (context) => const AlarmSet(),
            AlarmStop.id: (context) => const AlarmStop(),
          },
          builder: (context, child) => Stack(
            children: [child!, const DropdownAlert()],
          ),
        );
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: Scaffold(
        backgroundColor: const Color(0xff222831),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add your app logo here
              Image.asset(
                'images/intro_images/icon.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
