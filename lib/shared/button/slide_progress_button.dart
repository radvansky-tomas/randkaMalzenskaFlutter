import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';

class SlideProgressButton extends StatefulWidget {
  final bool _isDone;
  final bool _isLast;
  final String _text;
  final int _stepId;
  final String _firebaseId;
  final VoidCallback _refreshStep;
  SlideProgressButton(this._isDone, this._isLast, this._text, this._refreshStep,
      this._firebaseId, this._stepId);
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SlideTransition(
        position: animation,
        child: TextButton(
          onPressed: () {
            ConnectionService service = new ConnectionService();
            if (widget._isDone) {
              Navigator.pop(context);
            } else {
              if (!widget._isLast) {
                service
                    .increaseSubStepProgress(widget._stepId, widget._firebaseId)
                    .whenComplete(() => {
                          widget._refreshStep(),
                          Navigator.pop(context),
                        });
              } else {
                service
                    .increaseStepProgress(widget._stepId, widget._firebaseId)
                    .whenComplete(() => {
                          widget._refreshStep(),
                          Navigator.pop(context),
                        });
              }
            }
          },
          child: Text(
            widget._text,
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
