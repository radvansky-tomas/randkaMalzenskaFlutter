import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/video/video_button.dart';

class ImageButtonWithText extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: _onPressed,
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: _isAvailable ? Colors.white70 : Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Container(
            color: _isAvailable
                ? Colors.black54.withOpacity(0.0)
                : Colors.black54.withOpacity(0.6),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                (_isAvailable && !_isDone)
                    ? VideoButton(_assetName)
                    : Ink.image(
                        image: AssetImage("assets/images/$_assetName.jpg"),
                        fit: BoxFit.cover),
                Container(
                  color: Colors.black54.withOpacity(0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _stepName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isAvailable ? Colors.white : Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: _isDone,
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
