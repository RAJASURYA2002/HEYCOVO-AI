// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/home/home_page.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:math';

class CreateAccount extends StatefulWidget {
  static const String id = "createaccount_screen";
  const CreateAccount({super.key});
  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final localData = Hive.box('userdata');
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String userName = "";
  String userNameError = "";
  String eMail = "";
  String eMailError = "";
  String password = "";
  String passwordError = "";
  String headline = "";
  String mobile = "";
  String mobileError = "";
  Random random = Random();
//  int id = random.nextInt(10000000);
  bool _isLoaderVisible = false;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    getData();
  }

  Future<int> getData() async {
    final meassage = await _firestore.collection("UserData").get();
    int id = random.nextInt(10000000);
    for (var message in meassage.docs) {
      var messageid = message["messageid"];
      if (messageid == id) {
        id = random.nextInt(10000000);
      }
    }
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Colors.grey.withOpacity(0.8),
      useDefaultLoading: false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AnimationText(
                        text: "HEYCONVO",
                        size: 50,
                      ).animate().fadeIn(duration: 3.seconds),
                      const AnimationText(
                        text: "Your AI Friend",
                        size: 22,
                      ).animate().scale(duration: 2.seconds),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.fromLTRB(25, 45.0, 10, 0),
                  decoration: const BoxDecoration(
                    color: Color(0xffd3d3d3),
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(45)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Ktext(
                          text: "Create Account",
                          color: "#212b36",
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                        ),
                        const Ktext(
                          text: "Enter your credentials to continue",
                          color: "#3b3d3c",
                          fontSize: 11.6,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.normal,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextBox(
                          text: "User Name",
                          icon: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          error: userNameError == "" ? null : userNameError,
                          onChanged: (value) {
                            userName = value;
                          },
                          textInputType: TextInputType.name,
                          filled: false,
                        ),
                        TextBox(
                          text: "Mobile Number",
                          icon: const Icon(
                            Icons.contact_phone,
                            color: Colors.black,
                          ),
                          error: userNameError == "" ? null : userNameError,
                          onChanged: (value) {
                            mobile = value;
                          },
                          textInputType: TextInputType.phone,
                          filled: false,
                        ),
                        TextBox(
                          text: "Enter E-Mail Address",
                          icon: const Icon(
                            Icons.mail,
                            color: Colors.black,
                          ),
                          error: eMailError == "" ? null : eMailError,
                          onChanged: (value) {
                            eMail = value;
                          },
                          textInputType: TextInputType.emailAddress,
                          filled: false,
                        ),
                        TextBox(
                          text: "Headline",
                          icon: const Icon(
                            Icons.title,
                            color: Colors.black,
                          ),
                          error: eMailError == "" ? null : eMailError,
                          onChanged: (value) {
                            headline = value;
                          },
                          textInputType: TextInputType.name,
                          filled: false,
                        ),
                        TextBox(
                          text: "Password",
                          icon: const Icon(
                            Icons.title,
                            color: Colors.black,
                          ),
                          error: eMailError == "" ? null : eMailError,
                          onChanged: (value) {
                            password = value;
                          },
                          textInputType: TextInputType.name,
                          filled: false,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();
                                  context.loaderOverlay.show(
                                      widgetBuilder: (progress) {
                                        return ReconnectingOverlay(
                                          progress != null
                                              ? progress as String
                                              : null,
                                        );
                                      },
                                      progress: 'Trying to reconnect');
                                  setState(() {
                                    _isLoaderVisible =
                                        context.loaderOverlay.visible;
                                  });
                                  int id = await getData();
                                  try {
                                    if (id.toString().length == 7) {
                                      if (mobile.length == 10 &&
                                          eMail != "" &&
                                          headline != "" &&
                                          userName != "") {
                                        await _auth
                                            .createUserWithEmailAndPassword(
                                                email: eMail,
                                                password: password);
                                        _firestore.collection("UserData").add({
                                          'e-mail': eMail,
                                          'headline': headline,
                                          'mobileNumber': mobile,
                                          'userName': userName,
                                          'messageid': id,
                                          'friends': [],
                                        });
                                        ksuccess("Account Create");
                                        localData.put("login", true);
                                        Navigator.pushNamed(context, Home.id);
                                      } else {
                                        kerror(" Data Invalid");
                                      }
                                    } else {
                                      kerror("Server bussy");
                                    }
                                  } catch (e) {
                                    if (e is FirebaseAuthException) {
                                      String errorMessage =
                                          e.message ?? 'An error occurred';
                                      kwarning(errorMessage);
                                      textEditingController.clear();
                                    }
                                  }
                                  if (_isLoaderVisible) {
                                    context.loaderOverlay.hide();
                                  }
                                  setState(() {
                                    _isLoaderVisible =
                                        context.loaderOverlay.visible;
                                  });
                                },
                                icon: const Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                ),
                                label: const Ktext(
                                  text: "CREATE",
                                  color: "#ffffff",
                                  fontSize: 18,
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          const Color(0xffea5455)),
                                  minimumSize: WidgetStateProperty.all(
                                      const Size(180.0, 50.0)),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Set to 0.0 for flat border
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
