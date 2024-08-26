import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:heyconvo/intro/terms_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int i = 1;
  String firstWord = "Welcome";
  String middleWord = "to";
  String endWord = "Heyconvo";
  String para =
      "Meet HeyConvo – Your vibrant AI buddy, seamlessly connecting with your daily tasks, turning the ordinary into extraordinary!";
  IconData tick = Icons.arrow_forward_ios;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIntro(i: i),
                Heading(
                  firstWord: firstWord,
                  middleWord: middleWord,
                  endWord: endWord,
                  durationText: 3,
                ),
                Defination(
                  para: para,
                  durationText: 2,
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  if (i == 1) {
                    setState(() {
                      firstWord = "Meet";
                      middleWord = "Your Buddy,";
                      endWord = "Heyconvo";
                      para =
                          "Here to Make Your Daily Life a Breeze - Turning Everyday Tasks into Smiles and High-Fives! 🎉✨";
                      i = 2;
                    });
                  } else if (i == 2) {
                    setState(() {
                      firstWord = "It's";
                      middleWord = "an";
                      endWord = "Development";
                      para =
                          "Embarking on a Journey Together - This is a Test Version, and Your Feedback is Invaluable for Our Continuous Improvement. Feel Free to Share Your Thoughts and Help Shape HeyConvo into the Perfect Companion for You!";
                      tick = Icons.check;
                      i = 3;
                    });
                  } else {
                    i = 1;
                    Navigator.pop(context);
                    Navigator.pushNamed(context, TermsScreen.id);
                  }
                },
                backgroundColor: const Color(0xffdbe6fb),
                shape: const CircleBorder(),
                child: Icon(
                  tick,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Defination extends StatelessWidget {
  const Defination({super.key, required this.para, required this.durationText});

  final String para;
  final int durationText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Text(
        para,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14.0,
          color: Color(0xff989898),
          decoration: TextDecoration.none,
          fontFamily: 'Poppins',
        ),
      ).animate().scale(delay: 1.seconds, duration: durationText.seconds),
    );
  }
}

class Heading extends StatelessWidget {
  const Heading(
      {super.key,
      required this.firstWord,
      required this.middleWord,
      required this.endWord,
      required this.durationText});

  final String firstWord;
  final String middleWord;
  final String endWord;
  final int durationText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: firstWord,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        children: [
          const TextSpan(text: " "),
          TextSpan(text: middleWord),
          const TextSpan(text: " "),
          TextSpan(
            text: endWord,
            style: const TextStyle(
              color: Color(0xff0a53ea),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: durationText.seconds);
  }
}

class ImageIntro extends StatelessWidget {
  const ImageIntro({
    super.key,
    required this.i,
  });

  final int i;
  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('images/intro_images/intro_$i.png'),
      width: 250,
      height: 250,
    ).animate().fadeIn(duration: i.seconds);
  }
}
