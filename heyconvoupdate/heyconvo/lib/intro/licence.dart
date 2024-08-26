import 'package:flutter/material.dart';

class Licence extends StatelessWidget {
  static const String id = "licence";
  const Licence({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('HeyConvo Guidelines'),
          backgroundColor: const Color(0xff6d84bc),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HeyConvo Guidelines',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6d84bc),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Welcome to HeyConvo - Your Friendly Voice Assistant!',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6d84bc),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'At HeyConvo, we strive to be your reliable friend and guide. As you embark on this journey with us, please take a moment to review our guidelines:',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff9a9a9a),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '1. Be Respectful:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6d84bc),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'HeyConvo values respect and kindness. Please communicate with HeyConvo as you would with a friend, maintaining a positive and friendly tone.',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff9a9a9a),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '2. Privacy First:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6d84bc),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'Your privacy is our priority. HeyConvo respects your personal information and will handle it with the utmost care. Review our Privacy Policy for more details.',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff9a9a9a),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '3. Helpful Suggestions:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6d84bc),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'HeyConvo is here to assist you. Feel free to ask questions, seek guidance, or request information. We\'re here to make your life easier!',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff9a9a9a),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '4. Enjoy the Journey!',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6d84bc),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'By using HeyConvo, you agree to abide by these guidelines. Let\'s make this journey together enjoyable and enriching!',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff9a9a9a),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '4. Testing Version v1.0.0',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff6d84bc),
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'In this version, we are thrilled to introduce HeyConvo as your friendly voice assistant. Our testing version aims to provide you with a sneak peek into the exciting world of HeyConvo, where your feedback plays a crucial role in shaping the future of this innovative companion.',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff9a9a9a),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Feel free to explore and interact with HeyConvo as it assists you in your daily tasks. Your valuable feedback is highly appreciated as we work towards refining and enhancing HeyConvo to make it the perfect companion for you.',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff9a9a9a),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Thank you for being a part of HeyConvo\'s journey. Let the testing adventures begin!"',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff9a9a9a),
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(height: 18.0),
                Text(
                  '© HeyConvo 2024-v1.0.0. All rights reserved.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Color(0xff9a9a9a),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
