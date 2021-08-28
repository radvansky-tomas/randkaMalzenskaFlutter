import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/blog.dart';
import 'package:randka_malzenska/screens/blog/blog_card.dart';
import 'package:randka_malzenska/screens/step/drawer/step_drawer.dart';
import 'package:randka_malzenska/services/rest/connection_service.dart';

class BlogScreen extends StatefulWidget {
  final User _user;
  BlogScreen(this._user);
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  ConnectionService connectionService = new ConnectionService();
  Future<List<Blog>?>? blogs;

  @override
  void initState() {
    super.initState();
    blogs = connectionService.getBlogs();
  }

  @override
  Widget build(BuildContext context) {
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
                body: ListView(
                  children: [...awaitedBlog.map((e) => BlogCard(e))],
                ));
          } else if (snapshot.hasError) {
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
}
