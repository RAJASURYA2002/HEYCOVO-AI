import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heyconvo/page/AIpdf/localstorage.dart';
import 'package:heyconvo/page/chat_Screen/chat.dart';
import 'package:heyconvo/page/home/widget.dart';
import 'package:heyconvo/page/webview/webview_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFDisplay extends StatefulWidget {
  const PDFDisplay({super.key, this.path});
  final String? path;
  @override
  State<PDFDisplay> createState() => _PDFDisplayState();
}

class _PDFDisplayState extends State<PDFDisplay> {
  late PdfViewerController _pdfViewerController;
  late TextEditingController _searchTextController;
  final UndoHistoryController _undoHistoryController = UndoHistoryController();
  final PanelController _panelController = PanelController();
  final double _panelHeightOpen = 100;
  Widget panel = const AskAI();
  PdfPageLayoutMode pageLayoutMode = PdfPageLayoutMode.continuous;
  Color layout = const Color(0xffEEEEEE);
  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _searchTextController = TextEditingController();
    pdfname();
  }

  String pdftitle = "";
  void pdfname() {
    List<String> parts = widget.path!.split("/");
    pdftitle = parts[parts.length - 1];
  }

  int changcount = 0;
  double initialZoomLevel = 1;
  Color undo = const Color(0xffEEEEEE).withOpacity(0.5);

  void _showSearch(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search 🔎'),
          content: TextField(
            controller: _searchTextController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(hintText: 'Search'),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                searchWord();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void searchWord() {
    String searchText = _searchTextController.text;
    if (searchText.isNotEmpty) {
      PdfTextSearchResult? result = _pdfViewerController.searchText(searchText);
      if (result.totalInstanceCount == 0) {
        // kwarning("No text found.😔");
      }
    }
  }

  @override
  void dispose() {
    // _undoHistoryController.dispose();
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121b22),
      appBar: AppBar(
        title: Text(
          pdftitle,
          style: const TextStyle(color: Color(0xffEEEEEE)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.open_with,
              color: Color(0xffEEEEEE),
              semanticLabel: 'Bookmark',
              size: 30,
            ),
            onPressed: () {
              _panelController.open();
              setState(() {});
            },
          ),
        ],
      ),
      body: SlidingUpPanel(
        color: const Color(0xff212121),
        maxHeight: _panelHeightOpen,
        minHeight: 0,
        controller: _panelController,
        panel: panel,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xff26343d),
                border: Border.all(color: const Color(0xff26343d), width: 5),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.folder,
                      color: Color(0xffEEEEEE),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.undo,
                      color: undo,
                    ),
                    onPressed: () {
                      _undoHistoryController.undo();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.redo,
                      color: undo,
                    ),
                    onPressed: () {
                      _undoHistoryController.redo();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.auto_stories,
                      color: layout,
                    ),
                    onPressed: () {
                      if (pageLayoutMode == PdfPageLayoutMode.continuous) {
                        initialZoomLevel = 1;
                        pageLayoutMode = PdfPageLayoutMode.single;
                        layout = const Color(0xffE178C5);
                      } else {
                        pageLayoutMode = PdfPageLayoutMode.continuous;
                        layout = const Color(0xffEEEEEE);
                        initialZoomLevel = 1;
                      }
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _showSearch(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_drop_up),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_drop_down),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: SfPdfViewer.file(
                initialZoomLevel: initialZoomLevel,
                undoController: _undoHistoryController,
                pageSpacing: 10,
                controller: _pdfViewerController,
                pageLayoutMode: pageLayoutMode,
                File(widget.path!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AskAI extends StatefulWidget {
  const AskAI({super.key});

  @override
  State<AskAI> createState() => _AskAIState();
}

class _AskAIState extends State<AskAI> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xff26343d),
            border: Border.all(color: const Color(0xff26343d), width: 5),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                },
                child: const CircleImage(
                  imagePath: "images/home/voice.png",
                  radius: 30,
                  borderColor: "EEEEEE",
                  borderWidth: 2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewPage(
                        name: "GOOGLE",
                        url: "https://www.google.com/",
                      ),
                    ),
                  );
                },
                child: const CircleImage(
                  imagePath: "images/home/google.png",
                  radius: 20,
                  borderColor: "EEEEEE",
                  borderWidth: 2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewPage(
                        name: "Google translate",
                        url: "https://translate.google.co.in/",
                      ),
                    ),
                  );
                },
                child: const CircleImage(
                  imagePath: "images/home/translate.png",
                  radius: 20,
                  borderColor: "EEEEEE",
                  borderWidth: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
