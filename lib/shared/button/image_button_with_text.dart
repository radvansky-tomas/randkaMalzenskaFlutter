import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/video/video_button.dart';

class ImageButtonWithText extends StatefulWidget {
  final String _assetName;
  final String _stepName;
  final bool _isDone;
  final bool _isAvailable;
  final VoidCallback _onPressed;
  ImageButtonWithText(
    this._assetName,
    this._onPressed,
    this._stepName,
    this._isDone,
    this._isAvailable,
  );

  @override
  _ImageButtonWithTextState createState() => _ImageButtonWithTextState();
}

class _ImageButtonWithTextState extends State<ImageButtonWithText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    Future<void>.delayed(Duration(seconds: 1), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: widget._onPressed,
        child: ScaleTransition(
          scale: _animation,
          child: Card(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: widget._isAvailable ? Colors.white70 : Colors.grey,
                  width: 1),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Container(
              color: widget._isAvailable
                  ? Colors.black54.withOpacity(0.0)
                  : Colors.black54.withOpacity(0.6),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  (widget._isAvailable && !widget._isDone)
                      ? VideoButton(widget._assetName)
                      : Ink.image(
                          image: AssetImage(
                              "assets/images/${widget._assetName}.jpg"),
                          fit: BoxFit.cover),
                  (widget._isAvailable && !widget._isDone)
                      ? Container()
                      : Container(
                          color: Colors.black54.withOpacity(0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  widget._stepName,
                                  style:
                                      // GoogleFonts.montserrat(
                                      //   textStyle:
                                      TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: widget._isAvailable
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              // ),
                              Checkbox(
                                value: widget._isDone,
                                onChanged: null,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
