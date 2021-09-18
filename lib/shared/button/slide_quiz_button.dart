import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/quiz/quiz_screen.dart';

class SlideQuizButton extends StatefulWidget {
  final int _quizId;
  SlideQuizButton(this._quizId);
  @override
  _SlideQuizButtonState createState() => _SlideQuizButtonState();
}

class _SlideQuizButtonState extends State<SlideQuizButton>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
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

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SlideTransition(
        position: animation,
        child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return QuizScreen(widget._quizId);
                  },
                ),
              );
            },
            child: Text('Idz do quizu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ))));
  }
}
