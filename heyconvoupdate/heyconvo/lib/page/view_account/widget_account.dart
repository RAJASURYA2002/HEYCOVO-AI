// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:heyconvo/constant.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class SettingBox extends StatelessWidget {
  const SettingBox(
      {super.key,
      this.icon1,
      this.icon2,
      this.text,
      this.onTap,
      this.fontsize});
  final IconData? icon1;
  final IconData? icon2;
  final String? text;
  final void Function()? onTap;
  final double? fontsize;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350,
        height: 60,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Color(0xff373737),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(40),
            right: Radius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon1,
                  color: const Color(0xffdde1e4),
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Ktext(
                  text: text,
                  color: "#dde1e4",
                  fontFamily: "Roboto",
                  fontSize: fontsize,
                  fontWeight: FontWeight.w300,
                ),
              ],
            ),
            Icon(
              icon2,
              color: const Color(0xffdde1e4),
              size: 35,
            ),
          ],
        ),
        
      ),
    );
  }
}

class CopyLinkBox extends StatelessWidget {
  final String linkText;

  const CopyLinkBox({super.key, required this.linkText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              readOnly: true,
              controller: TextEditingController(text: linkText),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () {
              _copyToClipboard(linkText, context);
            },
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard'),
      ),
    );
  }
}

String privacy =
    "Information We Collect:\n 1:User Provided Information:\nWhen you create an account, we may collect personal information such as your name, email address, and phone number.\nIf you choose to connect your HeyConvo account with third-party services, we may collect information from those services.\n2:Messages and Communication:\nWe securely store and process your messages to enable you to communicate with others through the HeyConvo platform.\nHow We Use Your Information:\n1:To Provide and Improve Our Services:\nWe use your information to deliver, maintain, and improve HeyConvo's features and functionality.\n2:Communication:\nWe may use your contact information to send you important updates, announcements, and support-related messages.\nData Security:\n1:Encryption:\nWe implement industry-standard encryption and security measures to protect your data during transmission and storage.\n3:Access Controls:\nAccess to user data is restricted to authorized personnel who need it to perform their duties.\nSharing Your Information:\n1:Third-Party Integrations:\nWe may integrate with third-party services to enhance your HeyConvo experience. Please review the privacy policies of these services for details on how they handle your information.\n2:Legal Compliance:\nWe may disclose your information when required by law or in response to legal requests.\nChanges to this Privacy Policy:\nChanges to this Privacy Policy:\nContact Us:\nIf you have any questions, concerns, or requests regarding your privacy or this Privacy Policy, you can contact us at [contact@heyconvo.com].";
Widget kprivacy = Padding(
  padding: const EdgeInsets.all(8.0),
  child: Column(
    children: [
      Container(
        width: 70,
        decoration: const BoxDecoration(
          color: Colors.purple,
          border: Border(bottom: BorderSide(color: Colors.purple, width: 5.0)),
        ),
      ),
      const Ktext(
        text: "Privacy Policy for HeyConvo",
        color: "#dde1e4",
        fontFamily: "Roboto",
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
      const Ktext(
        text: "Effective Date: [18/12/2024]",
        color: "#dde1e4",
        fontFamily: "Roboto",
        fontSize: 15,
        fontWeight: FontWeight.w900,
      ),
      const SizedBox(
        height: 10,
      ),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Ktext(
                text:
                    'HeyConvo ("we," "our," or "us") is committed to protecting the privacy and security of our users. This Privacy Policy outlines how we collect, use, disclose, and safeguard your information when you use HeyConvo, including any related services, features, and applications (collectively referred to as the "Services").',
                color: "#dde1e4",
                fontFamily: "Roboto",
                fontSize: 15,
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 10,
              ),
              Ktext(
                text: privacy,
                color: "#dde1e4",
                fontFamily: "Roboto",
                fontSize: 15,
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);
// ignore: must_be_immutable
class EditAccount extends StatelessWidget {
   EditAccount({
    super.key,
    this.id,this.mail,this.mobile,this.user
  });
  String? user;
  String? mail;
  String? mobile;
  int? id;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          decoration: const BoxDecoration(
            color: Colors.purple,
            border: Border(bottom: BorderSide(color: Colors.purple, width: 5.0)),
          ),
        ),
        const Ktext(
          text: "Edit Account",
          color: "#dde1e4",
          fontFamily: "Roboto",
          fontSize: 25,
          fontWeight: FontWeight.w900,
          textAlign: TextAlign.justify,
        ),
        const SizedBox(
          height: 10,
        ),
         Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SettingBox(
                icon1: Icons.person,
                icon2: Icons.chevron_right,
                text: user,
              ),
              SettingBox(
                icon1: Icons.email,
                icon2: Icons.chevron_right,
                text: mail,
              ),
              SettingBox(
                icon1: Icons.contact_phone,
                icon2: Icons.chevron_right,
                text: "$mobile",
              ),
              SettingBox(
                icon1: Icons.api,
                icon2: Icons.chevron_right,
                text: "$id",
                fontsize: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
Widget kHelp = Column(
  children: [
    Container(
      width: 70,
      decoration: const BoxDecoration(
        color: Colors.purple,
        border: Border(bottom: BorderSide(color: Colors.purple, width: 5.0)),
      ),
    ),
    const Ktext(
      text: "Help & Supportt",
      color: "#dde1e4",
      fontFamily: "Roboto",
      fontSize: 25,
      fontWeight: FontWeight.w900,
      textAlign: TextAlign.justify,
    ),
    const SizedBox(
      height: 10,
    ),
    const Expanded(
      child: Column(
        children: [
          SettingBox(
            icon1: Icons.help,
            icon2: Icons.chevron_right,
            text: "9840864118",
            fontsize: 25,
          ),
        ],
      ),
    ),
    const SizedBox(
      height: 10,
    ),
    const Ktext(
      text: "24/7 Service --HEYCONVO-2024",
      color: "#dde1e4",
      fontFamily: "Roboto",
      fontSize: 18,
      fontWeight: FontWeight.w100,
      textAlign: TextAlign.center,
    ),
  ],
);
Widget kinvite = const Column(
  children: [
    CopyLinkBox(
      linkText: 'https://heyconvo/apk/share.com',
    ),
  ],
);
