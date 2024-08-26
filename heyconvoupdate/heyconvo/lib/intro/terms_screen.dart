import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:heyconvo/account/createaccount_screen.dart';
import 'package:heyconvo/account/login_screen.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/intro/licence.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});
  static const String id = "terms_screen";

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool check = false;
  int _current = 0;
  // final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    List<InlineSpan> kterms = [
      TextSpan(
          text: "HeyConvo Privacy Terms ",
          style: const TextStyle(color: Color(0xff6d84bc)),
          recognizer: TapGestureRecognizer()
            ..onTap = () => Navigator.pushNamed(context, Licence.id)),
      const TextSpan(text: "and "),
      TextSpan(
          text: "HeyConvo User Agreement ",
          style: const TextStyle(color: Color(0xff6d84bc)),
          recognizer: TapGestureRecognizer()
            ..onTap = () => Navigator.pushNamed(context, Licence.id)),
      const TextSpan(
          text:
              'to learn about how we provide you with services and process your personal data. By tapping "Agree", you agree to the above.'),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('images/intro_images/icon.png'),
              radius: 30.0,
            ).animate().fadeIn(duration: 2.seconds),
            const Text(
              "HeyConvo",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xff9a9a9a),
                  fontWeight: FontWeight.w900,
                  fontSize: 25.0,
                  decoration: TextDecoration.none),
            ).animate().fadeIn(duration: 3.seconds),
            const Text(
              "Your personal Assistant",
              style: TextStyle(
                  color: Color(0xffb4b4b4),
                  fontSize: 17.0,
                  fontFamily: 'Poppins',
                  decoration: TextDecoration.none),
            ).animate().fadeIn(duration: 3.seconds),
            const SizedBox(
              height: 25,
            ),
            CarouselSlider(
              items: kimageSliders,
              // carouselController: _controller,
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ).animate().fadeIn(delay: 2.seconds, duration: 3.seconds),
            const SizedBox(
              height: 10,
            ),
            Text(
              kmessage[_current],
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xffb4b4b4),
                  fontSize: 12.0,
                  fontFamily: 'Poppins',
                  decoration: TextDecoration.none),
            ).animate().fadeIn(duration: 3.seconds),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: kimgList.asMap().entries.map((entry) {
                return GestureDetector(
                  // onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.red
                                : const Color(0xff6c8cda))
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 30.0,
            ),
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                text: 'To use "HeyConvo", read and agree to ',
                style: const TextStyle(color: Color(0xffb4b4b4), fontSize: 12),
                children: kterms,
              ),
            ).animate().fadeIn(duration: 3.seconds),
            Row(
              children: [
                Checkbox(
                  value: check,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        check = value;
                      }
                    });
                  },
                ),
                const Text(
                  "Join Heyconvo User Experience Improvement Plan",
                  style: TextStyle(color: Color(0xff5f5f5f), fontSize: 10),
                ).animate().fadeIn(duration: 3.seconds),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                  buttonName: "Log-In",
                  onpressed: () {
                    if (check == true) {
                      Navigator.pushNamed(context, Login.id);
                    } else {
                      kwarning("please confirm Terms & User Agreement");
                    }
                  },
                ).animate().fadeIn(duration: 3.seconds),
                const SizedBox(
                  width: 30.0,
                ),
                Button(
                  buttonName: "Sign-up",
                  onpressed: () {
                    if (check == true) {
                      Navigator.pushNamed(context, CreateAccount.id);
                    } else {
                      kwarning("please confirm Terms & User Agreement");
                    }
                  },
                ).animate().fadeIn(duration: 3.seconds),
              ],
            )
          ],
        ),
      )),
    );
  }
}

class Button extends StatelessWidget {
  const Button({super.key, required this.buttonName, this.onpressed});
  final String? buttonName;
  final VoidCallback? onpressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(const Color(0xff668bdc)),
        minimumSize: WidgetStateProperty.all(const Size(100.0, 40.0)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Set to 0.0 for flat border
          ),
        ),
      ),
      child: Text(
        buttonName!,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
// To use "EasyShare", read and agree to EasyShare Privacy
// Terms and EasyShare User Agreement to learn about how we provide you with services and process your personal data. By tapping "Agree", you agree to the above.