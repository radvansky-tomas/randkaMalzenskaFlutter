import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String answerText;
  final VoidCallback selectHandler;

  Answer(this.answerText, this.selectHandler);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            answerText,
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: selectHandler,
      ),
    );
  }
}
