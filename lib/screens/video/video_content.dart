import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoContent extends StatefulWidget {
  final String _url;
  final String? _image;
  VideoContent(this._url, this._image);
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
      duration: Duration(seconds: 1),
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
      startAt: Duration(milliseconds: 50),
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
            child: widget._image == null
                ? Chewie(controller: chewieController)
                : chewieController.isPlaying
                    ? Chewie(controller: chewieController)
                    : Stack(children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.network(widget._image!),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ClipOval(
                            child: Material(
                              color: Colors.black.withOpacity(0.65),
                              child: InkWell(
                                splashColor: Colors.white, // Splash color
                                onTap: () {
                                  chewieController.play();
                                  setState(() {});
                                },
                                child: Container(
                                  child: SizedBox(
                                      width: 65,
                                      height: 65,
                                      child: Icon(
                                        Icons.play_arrow,
                                        size: 34.0,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
          )
        : Container();
  }
}
