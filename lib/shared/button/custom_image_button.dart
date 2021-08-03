import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/sub_step.dart';

class CustomImageButton extends StatelessWidget {
  final SubStep subStep;
  final VoidCallback selectHandler;
  CustomImageButton(this.subStep, this.selectHandler);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: selectHandler,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent)),
      label: Text(
        subStep.label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      icon: Container(
        width: 100,
        child: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/c/c0/An_example_animation_made_with_Pivot.gif'),
      ),
    );
  }
}
