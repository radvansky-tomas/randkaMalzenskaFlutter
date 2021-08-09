import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoSkipableScreen extends StatefulWidget {
  final String _url;
  VideoSkipableScreen(this._url);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoSkipableScreen> {
  late VideoPlayerController _controller;
  late ChewieController chewieController;
  late Chewie playerWidget;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    _controller = VideoPlayerController.network(widget._url);

    await Future.wait([
      _controller.initialize().then((value) => {
            _controller.addListener(() {
              setState(() {
                if (!_controller.value.isPlaying &&
                    _controller.value.isInitialized &&
                    (_controller.value.duration ==
                        _controller.value.position)) {
                  setState(() {});
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                }
              });
            })
          }),
    ]);
    _createChewieController();
    setState(() {});
    // _controller.play();
  }

  void _onSkipPressed() {
    chewieController.pause();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: _controller,
      allowFullScreen: false,
      showControls: true,
      customControls: Stack(
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
      ),
      fullScreenByDefault: true,
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
