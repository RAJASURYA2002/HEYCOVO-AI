import 'package:flutter/material.dart';
import 'package:heyconvo/constant.dart';
import 'package:webview_universal/webview_universal.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, this.url, this.name});
  final String? url;
  final String? name;

  @override
  // ignore: library_private_types_in_public_api
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController webViewController = WebViewController();
  @override
  void initState() {
    super.initState();
    webViewController.init(
      context: context,
      setState: setState,
      uri: Uri.parse(widget.url!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Ktext(
          text: widget.name,
          color: "#EEEEEE",
          fontFamily: "Poppins",
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Color(0xffEEEEEE),
              size: 30,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Color(0xffEEEEEE),
              size: 30,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: WebView(
        controller: webViewController,
      ),
    );
  }
}
