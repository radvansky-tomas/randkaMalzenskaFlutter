import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/blog.dart';
import 'package:randka_malzenska/screens/step/drawer/step_drawer.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';
import 'package:randka_malzenska/shared/SizeConfig.dart';

import 'SingleNewsScreen.dart';

class NewsHomeScreen extends StatefulWidget {
  final User _user;
  NewsHomeScreen(this._user);
  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  ConnectionService connectionService = new ConnectionService();
  Future<List<Blog>?>? blogs;

  @override
  void initState() {
    super.initState();
    blogs = connectionService.getBlogs();
  }

  late ThemeData themeData;

  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    MySize().init(context);
    return FutureBuilder<List<Blog>?>(
        future: blogs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<Blog> awaitedBlog = snapshot.data!;
            return Scaffold(
              backgroundColor: Colors.black,
              drawer: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.black,
                  ),
                  child: StepDrawer(1, widget._user)),
              appBar: AppBar(
                backgroundColor: Colors.grey[900],
                title: Text(
                  'Blog',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: Scaffold(
                  backgroundColor: Colors.black,
                  body: Container(
                    margin: EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          firstChild(awaitedBlog.first),
                          ...awaitedBlog.skip(1).map((e) => singleChild(e))
                        ],
                      ),
                    ),
                  )),
            );
          } else if (snapshot.hasError) {
            log('WYSTAPIL BLAD PRZY RENDEROWANIU BLOGA: ' +
                snapshot.error.toString());
            return Scaffold(
              backgroundColor: Colors.black,
              drawer: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.black,
                  ),
                  child: StepDrawer(1, widget._user)),
              appBar: AppBar(
                backgroundColor: Colors.grey[900],
                title: Text(
                  'Blog',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: Center(
                child: Text(
                  "Zapraszamy później :)",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.black,
              drawer: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.black,
                  ),
                  child: StepDrawer(1, widget._user)),
              appBar: AppBar(
                backgroundColor: Colors.grey[900],
                title: Text(
                  'Blog',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
        });
  }

  Widget firstChild(Blog blog) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SingleNewsScreen(blog)));
      },
      child: Container(
        margin: Spacing.top(24),
        decoration: BoxDecoration(
            color: Color(0xff212429),
            borderRadius: BorderRadius.all(Radius.circular(MySize.size24!)),
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
              borderRadius: BorderRadius.all(Radius.circular(MySize.size24!)),
              child: CachedNetworkImage(
                imageUrl: blog.image,
                placeholder: (context, url) => new CircularProgressIndicator(
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
                      blog.title,
                      style: TextStyle(
                          color: themeData.colorScheme.onBackground,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: Spacing.top(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          borderRadius:
                              BorderRadius.all(Radius.circular(MySize.size14!)),
                          child: Image(
                            image: AssetImage('./assets/images/serce-menu.png'),
                            height: MySize.size28,
                            width: MySize.size28,
                          ),
                        ),
                        SizedBox(
                          width: MySize.size16,
                        ),
                        Text(
                          blog.author ?? "Andrzej",
                          style: TextStyle(
                            color: themeData.colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(child: Container()),
                        Text(
                          blog.createdDate,
                          style: TextStyle(
                            color: themeData.colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget singleChild(Blog blog) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SingleNewsScreen(blog)));
      },
      child: Container(
        margin: Spacing.top(24),
        child: Row(
          children: [
            ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.all(Radius.circular(MySize.size16!)),
              child: CachedNetworkImage(
                width: MySize.size90,
                height: MySize.size72,
                fit: BoxFit.cover,
                imageUrl: blog.image,
                placeholder: (context, url) => new CircularProgressIndicator(
                  color: Colors.white,
                ),
                errorWidget: (context, url, error) => new Icon(
                  Icons.error,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: MySize.size16,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    blog.title,
                    style: TextStyle(
                        color: themeData.colorScheme.onBackground,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: Spacing.top(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color:
                              themeData.colorScheme.onBackground.withAlpha(160),
                          size: MySize.size20,
                        ),
                        SizedBox(
                          width: MySize.size8,
                        ),
                        Text(
                          blog.createdDate,
                          style: TextStyle(
                            color: themeData.colorScheme.onBackground,
                            letterSpacing: 0,
                          ),
                        ),
                        SizedBox(
                          width: MySize.size16,
                        ),
                        Icon(
                          Icons.timer_outlined,
                          color:
                              themeData.colorScheme.onBackground.withAlpha(160),
                          size: MySize.size20,
                        ),
                        SizedBox(
                          width: MySize.size8,
                        ),
                        Text(
                          "10 min",
                          style: TextStyle(
                            color: themeData.colorScheme.onBackground,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
