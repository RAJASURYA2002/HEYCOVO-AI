//import--------------------------//
// import 'dart:ui';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'dart:math' as math;

//import--------------------------//

//slider value --------------------------//
final List<String> kmessage = [
  "HeyConvo, your trusted friend",
  "HeyConvo: Making Your Daily Tasks Effortless"
];
final List<String> kimgList = [
  'images/intro_images/slider_1.png',
  'images/intro_images/slider_2.png'
];
final List<Widget> kimageSliders = kimgList
    .map((item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  // Image.network(item, fit: BoxFit.cover, width: 1000.0),
                  Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      // padding: EdgeInsets.symmetric(
                      //     vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                ],
              )),
        ))
    .toList();

//slider value --------------------------//
//Class-widget
//Animation
class AnimationText extends StatelessWidget {
  const AnimationText({super.key, this.text, this.size});
  final String? text;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return GradientAnimationText(
      text: Text(
        text!,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
        ),
      ),
      colors: const [
        Color(0xFF061A9C),
        Color(0xff92effd),
      ],
      duration: const Duration(seconds: 5),
      transform: const GradientRotation(math.pi / 4), // tranform
    );
  }
}

///TEXT
class Ktext extends StatelessWidget {
  const Ktext(
      {super.key,
      this.text,
      this.color,
      this.fontFamily,
      this.fontSize,
      this.fontWeight,
      this.textAlign});
  final String? text;
  final String? color;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    int indexToRemove = 0;
    String colorValue = color!.substring(0, indexToRemove) +
        color!.substring(indexToRemove + 1);
    colorValue = "0xff$colorValue";
    return Text(
      text!,
      textAlign: textAlign,
      style: TextStyle(
        color: Color(int.parse(colorValue)),
        fontFamily: GoogleFonts.getFont(fontFamily ?? "Poppins").fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

///InputFILED
class TextBox extends StatelessWidget {
  const TextBox(
      {super.key,
      this.text,
      this.icon,
      this.error,
      this.onChanged,
      this.obscureText,
      this.textInputType,
      this.filled});
  final String? text;
  final Icon? icon;
  final String? error;
  final bool? obscureText;
  final void Function(String)? onChanged;
  final TextInputType? textInputType;
  final bool? filled;
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      keyboardType: textInputType,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: filled,
        fillColor: Colors.white,
        label: Text(
          text!,
          style: const TextStyle(color: Color(0xff070F2B)),
        ),
        suffixIcon: icon,
        errorText: error,
      ),
    );
  }
}

// Error Notification
void ksuccess(String message) {
  Map<String, dynamic>? payload = <String, dynamic>{};
  payload["data"] = "content";
  AlertController.show(
    "Success",
    message,
    TypeAlert.success,
    payload,
  );
}

void kwarning(String message) {
  AlertController.show("Warn!", message, TypeAlert.warning);
}

void kerror(String message) {
  AlertController.show("Error", message, TypeAlert.error);
}

class ReconnectingOverlay extends StatelessWidget {
  final String? progress;

  const ReconnectingOverlay(this.progress, {super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            const Text(
              'Setting Account...',
            ),
            const SizedBox(height: 12),
            Text(
              progress ?? '',
            ),
          ],
        ),
      );
}

class NotificationButton extends StatelessWidget {
  const NotificationButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        top: 20,
        bottom: 10,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Theme.of(context).shadowColor,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final String title;

  const TopBar({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).shadowColor,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// String kplace = "Thokkavadi\nNamakkal";
