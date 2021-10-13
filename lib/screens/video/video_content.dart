import 'package:better_player/better_player.dart';
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
  late BetterPlayerController _betterPlayerController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
        backgroundColor: Colors.green,
        fontColor: Colors.white,
        outlineColor: Colors.black,
        fontSize: 20,
      ),
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        print("Current subtitle line: " +
            _betterPlayerController.renderedSubtitle.toString());
      }
    });
    _setupDataSource();

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

  void _setupDataSource() async {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget._url,
      subtitles: BetterPlayerSubtitlesSource.single(
        type: BetterPlayerSubtitlesSourceType.network,
        url: "https://rm2cms.x25.pl/assets/srt/MPiekara.pl_PL.srt",
        name: "My subtitles",
        selectedByDefault: true,
      ),
    );
    _betterPlayerController.setupDataSource(dataSource);
  }

  // https://rm2cms.x25.pl/assets/srt/MPiekara.pl_PL.srt

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
      showControls: true,
      showOptions: false,
      customControls: customControls(),
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

  double leftSubtitlePosition = -1500;

  Widget customControls() {
    return Stack(
      children: [
        MaterialControls(),
        Container(
          alignment: Alignment.topRight,
          padding: EdgeInsetsDirectional.only(top: 50, end: 15),
          child: IconButton(
            onPressed: () {
              setState(() {
                if (leftSubtitlePosition == 0) {
                  leftSubtitlePosition = -1500;
                } else {
                  leftSubtitlePosition = 0;
                }
              });
            },
            icon: (Icon(
              Icons.subtitles,
              color: Colors.white,
              size: 20,
            )),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _controller.value.isInitialized
        ? SlideTransition(
            position: animation,
            child: widget._image == null
                ? BetterPlayer(controller: _betterPlayerController)
                : chewieController.isPlaying
                    ? BetterPlayer(controller: _betterPlayerController)
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
