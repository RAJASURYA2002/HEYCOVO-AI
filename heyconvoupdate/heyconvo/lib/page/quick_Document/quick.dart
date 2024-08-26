import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/AIpdf/pdfview.dart';
import 'package:heyconvo/page/home/widget.dart';
import 'package:heyconvo/page/quick_Document/speechanalysis.dart';
import 'package:speech_to_text/speech_to_text.dart';

class QuickDocument extends StatefulWidget {
  const QuickDocument({super.key});

  @override
  State<QuickDocument> createState() => _QuickDocumentState();
}

class _QuickDocumentState extends State<QuickDocument> {
  SpeechToText speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  bool isListening = false;
  String lastWords = '';
  var answer = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
    initTextToSpeech();
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
          // textEditingController.text = lastWords;
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

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.speak(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: const Center(
                child: CircleIcon(
                  backgroundColor: "#78A083",
                  iconData: Icons.mic,
                  iconColor: "#ffffff",
                  radius: 130,
                  iconSize: 250,
                ),
              ),
              onLongPressStart: (details) {
                FocusScope.of(context).unfocus();
                startListening();
                ksuccess("HeyConvo Listening");
              },
              onLongPressEnd: (details) {
                kwarning("HeyConvo is not Listening");
                const duration = Duration(seconds: 1);
                Timer(duration, () async {
                  stopListening();
                  var answer = await replay(lastWords);
                  if (answer.contains(".pdf")) {
                    await systemSpeak("openning in heyconvo AI pdf reader");
                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFDisplay(
                          path: answer,
                        ),
                      ),
                    );

                    return;
                  }
                  await systemSpeak(answer);
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Ktext(
              text: "Talk to HeyConvo Personal Assistant ",
              color: "#eeeeee",
              fontSize: 20,
              fontWeight: FontWeight.w900,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

//networking//



// /storage/emulated/0/Download/heconvo/aadhar.pdf