import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoContentWithConfig extends StatefulWidget {
  final String _url;
  final String? _image;
  final String? _subtitleUrl;
  VideoContentWithConfig(this._url, this._image, this._subtitleUrl);
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoContentWithConfig>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController animationController;
  late BetterPlayerController _betterPlayerController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      autoDispose: false,
      controlsConfiguration: BetterPlayerControlsConfiguration(
          enableOverflowMenu: widget._subtitleUrl != null,
          enablePlaybackSpeed: false,
          enableQualities: false,
          enableAudioTracks: false),
      fit: BoxFit.contain,
      subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
        backgroundColor: Colors.black,
        fontColor: Colors.white,
        outlineColor: Colors.black,
        fontSize: 16,
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
    if (widget._subtitleUrl != null) {
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget._url,
        subtitles: BetterPlayerSubtitlesSource.single(
          type: BetterPlayerSubtitlesSourceType.network,
          url: widget._subtitleUrl,
          name: "Polskie napisy",
          selectedByDefault: false,
        ),
      );
      _betterPlayerController.setupDataSource(dataSource);
    } else {
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget._url,
      );
      _betterPlayerController.setupDataSource(dataSource);
    }
  }

  // https://rm2cms.x25.pl/assets/srt/MPiekara.pl_PL.srt

  @override
  void dispose() {
    animationController.dispose();
    _betterPlayerController.dispose(forceDispose: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SlideTransition(
      position: animation,
      child: widget._image == null
          ? BetterPlayer(controller: _betterPlayerController)
          : _betterPlayerController.isPlaying() ?? false
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
                            _betterPlayerController.play();
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
    );
  }
}
