import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heyconvo/account/login_screen.dart';
// import 'package:flutter/widgets.dart';
import 'package:heyconvo/constant.dart';
import 'package:heyconvo/page/home/widget.dart';
import 'package:heyconvo/page/view_account/widget_account.dart';
import 'package:hive/hive.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ViewAccount extends StatefulWidget {
  const ViewAccount({super.key});
  static const String id = "account";
  @override
  State<ViewAccount> createState() => _ViewAccountState();
}

// PanelState defaultPanelState = PanelState.CLOSED;

class _ViewAccountState extends State<ViewAccount> {
  final _auth = FirebaseAuth.instance;
  final localData = Hive.box('userdata');
  @override
  void initState() {
    super.initState();
    getLocalValue();
  }

  String user = "";
  String mail = "";
  String headline = "";
  String mobile = "";
  int id = 0;
  void getLocalValue() {
    setState(() {
      user = localData.get("User");
      mail = localData.get("Email");
      headline = localData.get("Headline").toUpperCase();
      mobile = localData.get("MobileNumber");
      id = localData.get("ID");
    });
  }

  final PanelController _panelController = PanelController();
  double _panelHeightOpen = 500;
  Widget panel = const Text("");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xff212121),
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.dark_mode,
              size: 35,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SlidingUpPanel(
        color: const Color(0xff212121),
        maxHeight: _panelHeightOpen,
        minHeight: 0,
        controller: _panelController,
        panel: panel,
        body: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: CircleImage(
                  imagePath: "images/home/boy.png",
                  radius: 55,
                  borderColor: "#effded",
                  borderWidth: 3,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Ktext(
                text: user,
                color: "#ffffff",
                fontFamily: "Roboto",
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
              Ktext(
                text: '$id',
                color: "#5d5e60",
                fontFamily: "Roboto",
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 270,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xffffc107),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(40),
                    right: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Ktext(
                    text: headline,
                    color: "#191825",
                    fontFamily: "Roboto",
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SettingBox(
                  icon1: Icons.admin_panel_settings,
                  icon2: Icons.chevron_right,
                  text: "Privacy",
                  fontsize: 20,
                  onTap: () {
                    _panelController.open();
                    setState(() {
                      panel = kprivacy;
                      _panelHeightOpen = 500;
                    });
                  }),
              const SizedBox(
                height: 12,
              ),
              SettingBox(
                  icon1: Icons.edit,
                  icon2: Icons.chevron_right,
                  text: "Account",
                  fontsize: 20,
                  onTap: () {
                    _panelController.open();
                    setState(() {
                      panel = EditAccount(
                        id: id,
                        mail: mail,
                        mobile: mobile,
                        user: user,
                      );
                      _panelHeightOpen = 500;
                    });
                  }),
              const SizedBox(
                height: 12,
              ),
              SettingBox(
                icon1: Icons.help,
                icon2: Icons.chevron_right,
                text: "Help & Support",
                fontsize: 20,
                onTap: () {
                  _panelController.open();
                  setState(() {
                    panel = kHelp;
                    _panelHeightOpen = 200;
                  });
                },
              ),
              const SizedBox(
                height: 12,
              ),
              const SettingBox(
                icon1: Icons.settings,
                icon2: Icons.chevron_right,
                text: "Settings",
                fontsize: 20,
              ),
              const SizedBox(
                height: 12,
              ),
              SettingBox(
                icon1: Icons.person_add,
                icon2: Icons.chevron_right,
                text: "Intive a Friend",
                fontsize: 20,
                onTap: () {
                  _panelController.open();
                  setState(() {
                    panel = kinvite;
                    _panelHeightOpen = 100;
                  });
                },
              ),
              const SizedBox(
                height: 12,
              ),
              SettingBox(
                onTap: () {
                  _auth.signOut();
                  localData.put("login", false);
                  localData.put("repeat", true);
                  ksuccess("Logout successfully");
                  Navigator.pushNamed(context, Login.id);
                },
                icon1: Icons.logout,
                // icon2: Icons.chevron_right,
                text: "Logout",
                fontsize: 20,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
