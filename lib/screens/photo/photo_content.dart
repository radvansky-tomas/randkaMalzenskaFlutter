import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:randka_malzenska/shared/database_helpers.dart';

class CameraContent extends StatefulWidget {
  final String _label;
  final Photo? _photo;
  final VoidCallback _callback;
  CameraContent(this._label, this._photo, this._callback);

  @override
  _CameraContentState createState() => _CameraContentState();
}

class _CameraContentState extends State<CameraContent>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = Tween<Offset>(
      begin: Offset(-1.5, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    Future<void>.delayed(Duration(seconds: 1), () {
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SlideTransition(
        position: animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget._label,
              style: TextStyle(color: Colors.white),
            ),
            widget._photo != null
                ? Container(
                    height: 300, child: Image.file(File(widget._photo!.path!)))
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              child: Container(
                color: Color.fromARGB(255, 255, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: widget._callback,
                        child: Text(
                          "Zrób zdjęcie",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
