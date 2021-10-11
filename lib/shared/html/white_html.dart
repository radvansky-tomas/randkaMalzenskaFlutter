import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class WhiteHtml extends StatefulWidget {
  final String _data;
  WhiteHtml(this._data);

  @override
  _WhiteHtmlState createState() => _WhiteHtmlState();
}

class _WhiteHtmlState extends State<WhiteHtml>
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

    Future<void>.delayed(Duration(milliseconds: 500), () {
      animationController.forward();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SlideTransition(
      position: animation,
      child: Html(
        data: widget._data,
        style: {
          'div': Style(
              color: Colors.white,
              fontFamily: 'MontserratNasze',
              fontSize: FontSize.em(1)),
          'h1': Style(
              color: Colors.white,
              fontFamily: 'MontserratNasze',
              fontSize: FontSize.em(1.5)),
          'h2': Style(
              color: Colors.white,
              fontFamily: 'MontserratNasze',
              fontSize: FontSize.em(1.4)),
          'h3': Style(
              color: Colors.white,
              fontFamily: 'MontserratNasze',
              fontSize: FontSize.em(1.3)),
          'h4': Style(
              color: Colors.white,
              fontFamily: 'MontserratNasze',
              fontSize: FontSize.em(1.2)),
          'h5': Style(
              color: Colors.white,
              fontFamily: 'MontserratNasze',
              fontSize: FontSize.em(1.1)),
          'p': Style(
              color: Colors.white,
              fontFamily: 'MontserratNasze',
              fontSize: FontSize.em(1)),
          'ul': Style(
              color: Colors.white,
              fontFamily: 'MontserratNasze',
              fontSize: FontSize.em(1)),
          'li': Style(
              color: Colors.white,
              fontFamily: 'MontserratNasze',
              fontSize: FontSize.em(1)),
        },
      ),
    );
  }
}
