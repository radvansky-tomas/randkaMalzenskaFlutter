import 'package:flutter/material.dart';

class ImageButtonWithText extends StatelessWidget {
  final String _assetName;
  final String _stepName;
  final bool _isDone;
  final VoidCallback _onPressed;
  ImageButtonWithText(
    this._assetName,
    this._onPressed,
    this._stepName,
    this._isDone,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: _onPressed,
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Ink.image(
                image: AssetImage("assets/images/$_assetName.jpg"),
                fit: BoxFit.cover,
              ),
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
                          color: Colors.white,
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
    );
  }
}
