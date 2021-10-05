import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:randka_malzenska/models/blog.dart';
import 'package:randka_malzenska/shared/html/white_html.dart';

class BlogContent extends StatelessWidget {
  final Blog _blog;
  BlogContent(this._blog);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Blog',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(
          children: [
            CachedNetworkImage(
              imageUrl: _blog.image,
              placeholder: (context, url) => new CircularProgressIndicator(
                color: Colors.white,
              ),
              errorWidget: (context, url, error) => new Icon(
                Icons.error,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 14.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _blog.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      _blog.subtitle,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    WhiteHtml(_blog.content)
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
