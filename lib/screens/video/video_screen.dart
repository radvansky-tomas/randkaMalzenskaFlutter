import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/step/step_course_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final String _url;
  final Widget _routeWidget;
  final bool _showControls;
  VideoScreen(this._url, this._routeWidget, this._showControls);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  late ChewieController chewieController;
  late Chewie playerWidget;
  late SharedPreferences prefs;
  late StreamSubscription<User?> loginStateSubscription;

  @override
  void initState() {
    super.initState();
    _verifyUserIsLogged();
    initializePlayer();
    _initializePrefs().whenComplete(() {
      setState(() {});
    });
  }

  void _verifyUserIsLogged() {
    var authBloc = Provider.of<Auth>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((user) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StepCourseScreen(user)));
      }
    });
  }

  _initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> initializePlayer() async {
    _controller = VideoPlayerController.network(widget._url);

    await Future.wait([
      _controller.initialize().then((value) => {
            _controller.addListener(() {
              if (!_controller.value.isPlaying &&
                  _controller.value.isInitialized &&
                  (_controller.value.duration == _controller.value.position)) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
                prefs.setBool(PreferencesKey.introWatched, true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return widget._routeWidget;
                    },
                  ),
                );
              }
            })
          }),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _onSkipPressed() {
    chewieController.pause();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    prefs.setBool(PreferencesKey.introWatched, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return widget._routeWidget;
        },
      ),
    );
  }

  Widget customControls() {
    if (widget._showControls) {
      return Stack(
        children: [
          MaterialControls(),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsetsDirectional.all(30),
            child: IconButton(
              onPressed: _onSkipPressed,
              icon: (Icon(
                Icons.skip_next,
                color: Colors.white,
                size: 50,
              )),
            ),
          )
        ],
      );
    } else {
      return Container(
        alignment: Alignment.bottomRight,
        padding: EdgeInsetsDirectional.all(30),
        child: IconButton(
          onPressed: _onSkipPressed,
          icon: (Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 50,
          )),
        ),
      );
    }
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: _controller,
      allowedScreenSleep: false,
      allowFullScreen: false,
      showControls: true,
      // startAt: Duration(seconds: 2),
      customControls: customControls(),
      // fullScreenByDefault: true,
      autoPlay: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
    chewieController.addListener(() {
      if (chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    loginStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? Chewie(controller: chewieController)
          : Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
