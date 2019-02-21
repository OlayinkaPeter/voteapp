import 'package:flutter/material.dart';

class IdeaDetailsScreen extends StatelessWidget {

  final String title;
  final String description;
  final int vote;

  IdeaDetailsScreen(
    this.title,
    this.description,
    this.vote
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '$vote Votes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0
              ),
            ),
            onPressed: null,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            new Container(
              child: new Center(
                child: new Text(
                  title,
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0
                  ),
                ),
              ),
            ),
            new Container(
              child: new Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: new Text(
                    description,
                    softWrap: true,
                    style: new TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}