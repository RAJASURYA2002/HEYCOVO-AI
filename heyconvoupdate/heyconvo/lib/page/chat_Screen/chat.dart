import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/chat_Screen/chat_network.dart';
import 'package:heyconvo/page/home/widget.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:heyconvo/page/chat_Screen/openai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });
  static const String id = "chat";
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
//////////////////////////////////////////////////////
  SpeechToText speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  bool isListening = false;
  String lastWords = '';
  String inputword = '';
  String result = "";
  List<dynamic> savedmessages = [];
  List<Widget> kmessageDisplay = [];
  // final OpenAIService openAIService = OpenAIService();
  TextEditingController textEditingController = TextEditingController();
  final PageController controller = PageController(initialPage: 0);
  late DateTime now;
  late int month;
  late int day;
  late int year;
  late int hour;
  late int minute;
  late String amPm;
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    initSpeech();
    initTextToSpeech();
    getData();
    now = DateTime.now();
    month = now.month;
    day = now.day;
    year = now.year;
    hour = now.hour > 12
        ? now.hour - 12
        : now.hour; // Convert 24-hour format to 12-hour format
    minute = now.minute;
    amPm = now.hour >= 12 ? 'PM' : 'AM'; // Determine AM/PM based on hour
    AlertController.onTabListener(
        (Map<String, dynamic>? payload, TypeAlert type) {
      // print("$payload - $type");
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        isVisible = false;
      });
    });
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  void initSpeech() async {
    isListening = await speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    bool available = await speechToText.initialize();
    if (available) {
      // Start listening
      speechToText.listen(onResult: (result) {
        setState(() {
          lastWords = result.recognizedWords;
          textEditingController.text = lastWords;
        });
      });
      setState(() {
        isListening = true;
      });
    }
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  Future<void> getAns(String voiceInput) async {
    // Create an instance of GetAnsFromAi
    final getAnsFromAi = GetAnsFromAi();

    // Call the aiChat method using the instance
    final speech = await getAnsFromAi.aiChat(voiceInput);

    savedmessages.add({"Input": voiceInput, "Output": speech, "Time": "null"});
    addSavedMessage(savedmessages);
    String trimmedInput = speech?.trim() ?? '';
    List<String> words = trimmedInput.split(RegExp(r'\s+'));
    if (words.length <= 200) {
      await systemSpeak(speech ?? '');
      setState(() {
        isVisible = true;
      });
    }
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.speak(content);
  }

  void getData() async {
    Directory? externalDir = await getExternalStorageDirectory();
    Directory newFolder =
        Directory('${externalDir?.path}/Heyconvo/ai_message_json.json');
    File file = File(newFolder.path);
    if (file.existsSync()) {
      String jsonString = file.readAsStringSync();
      savedmessages = jsonDecode(jsonString);
      addSavedMessage(savedmessages);
    } else {
      kerror("File not found");
    }
  }

  void addSavedMessage(List<dynamic> saveMessage) {
    kmessageDisplay = [];
    for (var message in saveMessage) {
      String input = message["Input"];
      String output = message["Output"];
      kmessageDisplay.add(MessageBubble(
        text: input,
        isMe: true,
        time: "12:00 AM",
      ));
      kmessageDisplay.add(MessageBubble(
        text: output,
        isMe: false,
        time: "12:00 AM",
      ));
    }
    setState(() {
      FocusScope.of(context).unfocus();
      textEditingController.clear();
    });
  }

  void saveMessage(List<dynamic> savedmessages) async {
    Directory? externalDir = await getExternalStorageDirectory();
    Directory newFolder = Directory('${externalDir?.path}/Heyconvo');
    File file = File('${newFolder.path}/ai_message_json.json');
    if (file.existsSync()) {
      // Read the current content of the JSON file
      String jsonString = file.readAsStringSync();
      List<dynamic> existingData = jsonDecode(jsonString);
      // Update the existing data with the new data
      existingData.addAll(savedmessages.sublist(existingData.length));
      // Convert the updated data back to a JSON string
      String updatedJsonString = jsonEncode(existingData);
      // Write the updated JSON string back to the file
      file.writeAsStringSync(updatedJsonString);
      ksuccess(
          "Message Saved! I'll be here for you offline. Keep learning and exploring!");
    } else {
      kerror('File not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff222831),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(0, 0, 0, 1),
                  Color.fromRGBO(68, 22, 40, 1),
                ],
                stops: [0, 1],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleImage(
                    imagePath: "images/intro_images/icon.png",
                    radius: 20,
                    borderColor: "#4a1625",
                    borderWidth: 1,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Ktext(
                    text: "HEYCOVO AI",
                    color: "#ffffff",
                    fontFamily: "Roboto",
                    fontSize: 20,
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  saveMessage(savedmessages);
                },
                child: const Icon(
                  Icons.save,
                  color: Color(0xffFBF9F1),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(100, 55, 129, 1),
                      Color.fromRGBO(196, 56, 89, 1),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    DateChip(
                      date: DateTime(year, month, day),
                      color: const Color(0x558AD3D5),
                    ),
                    Expanded(
                      child: ListView(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        children: kmessageDisplay.reversed.toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // margin: const EdgeInsets.all(50),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              // height: 100,
              decoration: const BoxDecoration(
                color: Color(0xff222831),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 70,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: controller,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => {},
                              child: Image.asset(
                                'images/delete.png',
                                width: 50,
                                height: 50,
                              ),
                            ),
                            GestureDetector(
                              child: const CircleIcon(
                                backgroundColor: "#78A083",
                                iconData: Icons.mic,
                                iconColor: "#ffffff",
                                radius: 35,
                                iconSize: 40,
                              ),
                              onLongPressStart: (details) {
                                FocusScope.of(context).unfocus();
                                startListening();
                                ksuccess("HeyConvo Listening");
                              },
                              onLongPressEnd: (details) {
                                FocusScope.of(context).unfocus();
                                kwarning("HeyConvo is not Listening");
                                const duration = Duration(seconds: 1);
                                Timer(duration, () {
                                  stopListening();
                                  getAns(lastWords);
                                });
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Visibility(
                              visible: isVisible,
                              child: GestureDetector(
                                onTap: () {
                                  flutterTts.stop();
                                  setState(() {
                                    isVisible = false;
                                  });
                                },
                                child: const Icon(
                                  Icons.stop_circle,
                                  color: Colors.red,
                                  size: 45,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: TextField(
                                  maxLines: null, // Allow multiple lines
                                  keyboardType: TextInputType
                                      .multiline, // Enable multiline input
                                  controller: textEditingController,
                                  onChanged: (value) {
                                    inputword = value;
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    hintText: "Ask to HeyConvo",
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              child: const Icon(
                                Icons.send,
                                color: Colors.green,
                                size: 30,
                              ),
                              onTap: () {
                                getAns(inputword);
                                FocusScope.of(context).unfocus();
                                textEditingController.clear();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
