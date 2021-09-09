import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoContent extends StatefulWidget {
  final String _url;
  VideoContent(this._url);
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoContent>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late ChewieController chewieController;
  late Chewie playerWidget;
  late Animation<Offset> animation;
  late AnimationController animationController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    Future<void>.delayed(Duration(seconds: 1), () {
      animationController.forward();
    });
  }

  Future<void> initializePlayer() async {
    _controller = VideoPlayerController.network(widget._url);
    await Future.wait([_controller.initialize()]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: _controller,
      allowFullScreen: true,
      fullScreenByDefault: false,
      startAt: Duration(milliseconds: 5),
      autoInitialize: true,
      showOptions: false,
      looping: false,
      autoPlay: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    animationController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _controller.value.isInitialized
        ? SlideTransition(
            position: animation,
            child: Container(child: Chewie(controller: chewieController)))
        : Container();
  }
}
