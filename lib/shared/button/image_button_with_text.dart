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
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(min: 1.0, reverse: false);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: widget._onPressed,
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget._isAvailable
                                      ? Colors.white
                                      : Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
                            ),
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
    );
  }
}
