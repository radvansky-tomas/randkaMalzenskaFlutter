import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/photo/photo_screen.dart';
import 'package:randka_malzenska/screens/photo/photo_show_screen.dart';
import 'package:randka_malzenska/shared/database_helpers.dart';

class PreviewScreen extends StatefulWidget {
  final String? imgPath;
  final String? fileName;
  PreviewScreen({this.imgPath, this.fileName});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  Future<List<Photo>?>? _photos;
  int lenght = 0;

  @override
  void initState() {
    super.initState();
    _photos = _read();
  }

  // body: Image.file(File(widget.imgPath!)),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zdjęcia')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      // body: Image.file(File(widget.imgPath!)),
      body: Container(
        child: FutureBuilder<List<Photo>?>(
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.none) {
              print('project snapshot is null');
              return Container();
            }
            if (projectSnap.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
              // return Container();
            }
            if (projectSnap.data == null) {
              print('There is not data');
              return Container();
            }
            return Column(
              children: [
                Expanded(
                  flex: 9,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 1 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 0),
                    itemCount: projectSnap.data!.length,
                    itemBuilder: (context, index) {
                      Photo photo = projectSnap.data![index];
                      return GestureDetector(
                          onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PhotoScreen(photo.path),
                                  ),
                                ),
                              },
                          child: Image.file(File(photo.path!)));
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PhotoShowScreen(projectSnap.data!),
                        ),
                      ),
                    },
                    child: Text('ubogi pokaz slajdów'),
                  ),
                )
              ],
            );
          },
          future: _photos,
        ),
      ),
    );
  }
}

Future<List<Photo>?> _read() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  return await helper.queryPhoto();
}

// ListView.builder(
//                 itemCount: projectSnap.data!.length,
//                 itemBuilder: (context, index) {
//                   Photo photo = projectSnap.data![index];
//                   return Image.file(File(photo.path!));
//                 },
//               ),
