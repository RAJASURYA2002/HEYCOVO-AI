import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:heyconvo/constant.dart';
// import 'package:heyconvo/page/AIpdf/linker.dart';
import 'package:heyconvo/page/AIpdf/pdfview.dart';

class HomePage extends StatelessWidget {
  final FileManagerController controller = FileManagerController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
      controller: controller,
      child: Scaffold(
        appBar: appBar(context),
        body: FileManager(
          controller: controller,
          builder: (context, snapshot) {
            final List<FileSystemEntity> entities = snapshot;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              itemCount: entities.length,
              itemBuilder: (context, index) {
                FileSystemEntity entity = entities[index];
                return Card(
                  child: ListTile(
                    leading: FileManager.isFile(entity)
                        ? const Icon(Icons.feed_outlined)
                        : const Icon(Icons.folder),
                    title: Text(FileManager.basename(
                      entity,
                      showFileExtension: true,
                    )),
                    subtitle: subtitle(entity),
                    onTap: () async {
                      if (FileManager.isDirectory(entity)) {
                        controller.openDirectory(entity);
                      } else {
                        // Handle file tap
                        // print(entity.path);
                        if (entity.path.toLowerCase().endsWith('.pdf')) {
                          // Handle PDF file tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFDisplay(
                                path: entity.path,
                              ),
                            ),
                          );
                          // print("PDF file tapped: ${entity.path}");
                        } else {
                          kerror("The file does not support");
                        }
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text("File Manager"),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () async {
          await controller.goToParentDirectory();
        },
      ),
    );
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;
            return Text(
              FileManager.formatBytes(size),
            );
          }
          return Text(
            "${snapshot.data!.modified}".substring(0, 10),
          );
        } else {
          return const Text("");
        }
      },
    );
  }
}
