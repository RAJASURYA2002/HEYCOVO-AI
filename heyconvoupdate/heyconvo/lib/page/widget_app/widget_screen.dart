import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/AIpdf/localstorage.dart';
import 'package:heyconvo/page/ToDo/todo.dart';
import 'package:heyconvo/page/alarm/alarm.dart';
import 'package:heyconvo/page/chat_Screen/chat.dart';
import 'package:heyconvo/page/home/widget.dart';

class WidgetScreen extends StatefulWidget {
  const WidgetScreen({super.key});
  static const String id = "widget_screen";
  @override
  State<WidgetScreen> createState() => _WidgetScreenState();
}

class _WidgetScreenState extends State<WidgetScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xff212121),
          leading: IconButton(
            icon: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                size: 35,
                color: Colors.white,
              ),
            ),
            onPressed: () {},
          ),
          title: const Text(
            "Widget",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                App(
                  appIcon: "images/intro_images/icon.png",
                  appName: "HEYCONVO",
                  status: "Open",
                  star: 0.0,
                  reviews: 0.0,
                  like: 0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatScreen(),
                      ),
                    );
                  },
                ),
                App(
                  appIcon: "images/widget_icon/pdf.png",
                  appName: "AI PDF Reader",
                  status: "Open",
                  star: 0.0,
                  reviews: 0.0,
                  like: 0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                ),
                App(
                  appIcon: "images/widget_icon/ToDo.png",
                  appName: "ToDo",
                  status: "Open",
                  star: 0.0,
                  reviews: 0.0,
                  like: 0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TodoList(),
                      ),
                    );
                  },
                ),
                App(
                  appIcon: "images/widget_icon/weather.png",
                  appName: "Weather",
                  status: "Open",
                  star: 0.0,
                  reviews: 0.0,
                  like: 0,
                  onPressed: () {
                    ksuccess("No update available");
                  },
                ),
                App(
                  appIcon: "images/widget_icon/alarm.png",
                  appName: "AI Alarm",
                  status: "Open",
                  star: 0.0,
                  reviews: 0.0,
                  like: 0,
                  onPressed: () {
                    Navigator.pushNamed(context, AlarmSet.id);
                  },
                ),
                // const App(
                //   appIcon: "images/widget_icon/google.png",
                //   appName: "AI Translate",
                //   status: "Open",
                //   star: 0.0,
                //   reviews: 0.0,
                //   like: 0,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App(
      {super.key,
      this.appName,
      this.appIcon,
      this.status,
      this.star,
      this.like,
      this.reviews,
      this.onPressed});

  final String? appName;
  final String? appIcon;
  final String? status;
  final double? star;
  final double? reviews;
  final double? like;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 170,
      decoration: const BoxDecoration(color: Color(0xff222831)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleImage(
                imagePath: appIcon,
                radius: 35,
                borderColor: "#222831",
                borderWidth: 3,
              ),
              Ktext(
                text: "$appName\nVerfied✅",
                color: "#e3e3e3",
                fontFamily: "Roboto",
                fontSize: 18,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(const Color(0xffa8c8fb)),
                  minimumSize: WidgetStateProperty.all(const Size(120.0, 50.0)),
                ),
                onPressed: onPressed,
                child: Ktext(
                  text: status,
                  color: "#062d6e",
                  fontFamily: "Roboto",
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Ktext(
                text: "$star⭐\n$reviews reviews ℹ️",
                color: "#e3e3e3",
                fontFamily: "Roboto",
                fontSize: 18,
                textAlign: TextAlign.center,
              ),
              Ktext(
                text: "👍\n $like like",
                color: "#e3e3e3",
                fontFamily: "Roboto",
                fontSize: 18,
                textAlign: TextAlign.center,
              ),
              const Ktext(
                text: "v 1.0.0\nNo Update",
                color: "#8DECB4",
                fontFamily: "Roboto",
                fontSize: 18,
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
      ),
    );
  }
}
// "images/widget_icon/pdf.png"