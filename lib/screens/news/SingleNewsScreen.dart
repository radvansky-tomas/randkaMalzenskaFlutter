import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/blog.dart';
import 'package:randka_malzenska/shared/SizeConfig.dart';
import 'package:randka_malzenska/shared/html/white_html.dart';

class SingleNewsScreen extends StatefulWidget {
  final Blog _blog;
  SingleNewsScreen(this._blog);
  @override
  _SingleNewsScreenState createState() => _SingleNewsScreenState();
}

class _SingleNewsScreenState extends State<SingleNewsScreen> {
  late ThemeData themeData;

  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff212429),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xffd9d9d9),
                                      spreadRadius: MySize.size2,
                                      blurRadius: MySize.size8!,
                                      offset: Offset(0, MySize.size4!))
                                ]),
                            padding: EdgeInsets.all(12),
                            child: Icon(
                              Icons.chevron_left,
                              color: themeData.colorScheme.onBackground,
                              size: MySize.size20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MySize.size8,
                  ),
                  Expanded(
                      child: ListView(
                    padding: Spacing.fromLTRB(0, 16, 0, 16),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xff212429),
                            borderRadius: BorderRadius.all(
                                Radius.circular(MySize.size24!)),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff202020).withAlpha(120),
                                  blurRadius: MySize.size24!,
                                  spreadRadius: MySize.size4!)
                            ]),
                        child: Column(
                          children: [
                            ClipRRect(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(MySize.size24!)),
                              child: CachedNetworkImage(
                                imageUrl: widget._blog.image,
                                placeholder: (context, url) =>
                                    new CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                errorWidget: (context, url, error) => new Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              padding: Spacing.all(16),
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                      widget._blog.title,
                                      style: TextStyle(
                                          color: themeData
                                              .colorScheme.onBackground,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      margin: Spacing.top(16),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    MySize.size14!)),
                                            child: Image(
                                              image: AssetImage(
                                                  './assets/images/serce-menu.png'),
                                              height: MySize.size28,
                                              width: MySize.size28,
                                            ),
                                          ),
                                          SizedBox(
                                            width: MySize.size16,
                                          ),
                                          Text(
                                            widget._blog.author ?? "Andrzej",
                                            style: TextStyle(
                                              color: themeData
                                                  .colorScheme.onBackground,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(child: Container()),
                                          Text(
                                            "10 Jan, 2020",
                                            style: TextStyle(
                                              color: themeData
                                                  .colorScheme.onBackground,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: Spacing.top(24),
                        child: WhiteHtml(
                          widget._blog.content,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            )));
  }
}
