import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final Color color;
  final IconData icon;

  CustomIconButton(
      {required this.callback,
      required this.text,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Container(
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.all(Radius.circular(7))),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Icon(
                  icon,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
