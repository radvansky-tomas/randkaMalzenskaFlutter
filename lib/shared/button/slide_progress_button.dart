import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';

class SlideProgressButton extends StatefulWidget {
  final bool _isDone;
  final bool _isLast;
  final bool _isOnlySubStep;
  final String _text;
  final int _stepId;
  final String _firebaseId;
  final VoidCallback _refreshStep;
  SlideProgressButton(this._isDone, this._isLast, this._text, this._refreshStep,
      this._firebaseId, this._stepId, this._isOnlySubStep);
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
      duration: Duration(seconds: 2),
    );
    animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
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
        child: Container(
          color: Color.fromARGB(255, 21, 74, 118),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  ConnectionService service = new ConnectionService();
                  if (widget._isDone) {
                    Navigator.pop(context);
                  } else {
                    if (!widget._isLast) {
                      service
                          .increaseSubStepProgress(
                              widget._stepId, widget._firebaseId)
                          .whenComplete(() => {
                                widget._refreshStep(),
                                Navigator.pop(context),
                              });
                    } else {
                      if (widget._isOnlySubStep) {
                        //if there is one substep content is directly loaded in step screen, pop context not needed
                        service.increaseStepProgress(
                            widget._stepId, widget._firebaseId);
                      } else {
                        final snackBar = SnackBar(
                            content: Text(
                                'Gratulacje, ukończyłeś dzień! Zapraszamy jutro na następny :)'));

                        service
                            .increaseStepProgress(
                                widget._stepId, widget._firebaseId)
                            .whenComplete(() => {
                                  widget._refreshStep(),
                                  Navigator.pop(context),
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar)
                                });
                      }
                    }
                  }
                },
                child: Text(
                  widget._text,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ],
          ),
        ));
  }
}
