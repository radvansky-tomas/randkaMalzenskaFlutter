import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/screens/photo/photo_presentation_screen.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:randka_malzenska/shared/button/custom_icon_button.dart';

class SlideProgressButton extends StatefulWidget {
  final bool _isDone;
  final bool _isLastSubStep;
  final bool _isLastStep;
  final bool _isOnlySubStep;
  final String _text;
  final int _stepId;
  final String _firebaseId;
  final VoidCallback _refreshStep;
  final User _user;
  SlideProgressButton(
      this._isDone,
      this._isLastSubStep,
      this._isLastStep,
      this._text,
      this._refreshStep,
      this._firebaseId,
      this._stepId,
      this._isOnlySubStep,
      this._user);
  @override
  _SlideProgressButtonState createState() => _SlideProgressButtonState();
}

class _SlideProgressButtonState extends State<SlideProgressButton>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  // icon:
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SlideTransition(
        position: animation,
        child: CustomIconButton(
          callback: () {
            ConnectionService service = new ConnectionService();
            if (widget._isDone && !widget._isOnlySubStep) {
              Navigator.pop(context);
            } else if (widget._isDone && widget._isOnlySubStep) {
              _showDialog(
                  'Hej!', 'Ukończyłeś dzień po raz kolejny :)', context);
            } else {
              if (!widget._isLastSubStep) {
                service
                    .increaseSubStepProgress(widget._stepId, widget._firebaseId)
                    .whenComplete(() => {
                          widget._refreshStep(),
                          Navigator.pop(context),
                        });
              } else {
                if (widget._isOnlySubStep && !widget._isLastStep) {
                  //if there is one substep content is directly loaded in step screen, pop context not needed
                  service.increaseStepProgress(
                      widget._stepId, widget._firebaseId);
                } else if (widget._isLastStep) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PhotoPresentationScreen(widget._user);
                      },
                    ),
                  );
                } else {
                  service
                      .increaseStepProgress(widget._stepId, widget._firebaseId)
                      .whenComplete(() => {
                            widget._refreshStep(),
                            Navigator.pop(context),
                            _showDialog('Zapraszamy jutro!', 'Ukończyłeś dzień',
                                context)
                          });
                }
              }
            }
          },
          color: Color.fromARGB(255, 21, 74, 118),
          text: widget._text,
          icon: Icons.arrow_forward,
        ));
  }

  void _showDialog(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey[100],
          title: Text(title,
              style: TextStyle(
                color: Colors.black,
              )),
          content: Text(
            message,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 21, 74, 118))),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('OK',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            )
          ]),
    );
  }
}
