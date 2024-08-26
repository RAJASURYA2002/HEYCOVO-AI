// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:heyconvo/account/createaccount_screen.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/home/home_page.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String id = "login_screen";
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final localData = Hive.box('userdata');
  TextEditingController textEditingController = TextEditingController();
  bool _isLoaderVisible = false;
  String eMail = "";
  String eMailError = "";
  String password = "";
  String passwordError = "";
  final _auth = FirebaseAuth.instance;
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
                flex: 3,
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
                          text: "Welcome Back",
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
                        // TextBox(
                        //   text: "User Name",
                        //   icon: const Icon(Icons.person),
                        //   error: userNameError == "" ? null : userNameError,
                        //   onChanged: (value) {
                        //     userName = value;
                        //   },
                        //   filled: false,
                        // ),
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
                          filled: false,
                        ),
                        TextBox(
                          text: "Enter Password",
                          icon: const Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          error: passwordError == "" ? null : passwordError,
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: true,
                          filled: false,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
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
                                  try {
                                    final User =
                                        await _auth.signInWithEmailAndPassword(
                                            email: eMail, password: password);
                                    if (User != "") {
                                      ksuccess("logging success");
                                      localData.put("login", true);
                                      if (mounted) {
                                        Navigator.pushNamed(context, Home.id);
                                      }
                                      // Navigator.pushNamed(context, Home.id);
                                    } else {
                                      kwarning(
                                          "Invalid user,Create new account");
                                    }
                                  } catch (e) {
                                    if (e is FirebaseAuthException) {
                                      String errorMessage =
                                          e.message ?? 'An error occurred';
                                      kwarning(errorMessage);
                                      textEditingController.clear();
                                    }
                                    textEditingController.clear();
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
                                  text: "CONTINUE",
                                  color: "#ffffff",
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
                              const SizedBox(
                                height: 5,
                              ),
                              const Ktext(
                                text: "Forgot Password?",
                                color: "#0e0e0e",
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, CreateAccount.id),
                          child: const Ktext(
                            text: "Don't have an account? Register",
                            color: "#0e0e0e",
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        )
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
