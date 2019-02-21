import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vote_idea/screens/ideaDetails.dart';
import 'package:vote_idea/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashBoardScreen extends StatefulWidget {
    @override
    _DashBoardScreenState createState() => _DashBoardScreenState();
  }
  
  class _DashBoardScreenState extends State<DashBoardScreen> {
    String displayName = '';
    String photoUrl = '';
    String email = '';

    String ideaTitle;
    String description;
    int vote;

    CrudMethods crudObj = new CrudMethods();
    //QuerySnapshot votes;
    var votes;
    @override
    void initState() {
      crudObj.getData().then((results){
        votes = results;
      });

      this.displayName = '';
      this.photoUrl = '';
      this.email = '';
      FirebaseAuth.instance.currentUser()
      .then((value) {
        setState(() {
          this.displayName = value.displayName;
          this.email = value.email;
          this.photoUrl = value.photoUrl;
        });
      })
      .catchError((e) {
        print(e);
      });

      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('DashBoard'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                addDialog(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                crudObj.getData().then((results) {
                  setState(() {
                    votes = results;
                  });
                });         
              },
            )
          ],
        ),
        drawer: Drawer(
          child: Scaffold(
            body: Container(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      child: Image.network(photoUrl)
                    ),
                    accountName: Text(displayName),
                    accountEmail: Text(email),
                  ),
                  ListTileTheme(
              child: Card(
                child: ListTile(
                  title: Text('Add New Idea'),
                  leading: Icon(Icons.add),
                  onTap: () {
                    addDialog(context);
                  },
                ),
                elevation: 2.0,
              ),
            ),
                ],
              ),
            ),
            bottomNavigationBar: ListTileTheme(
              child: Container(
                color: Colors.blue,
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  leading: Icon(
                    FontAwesomeIcons.signOutAlt,
                    color: Colors.white,
                  ),
                  onTap: () {
                    FirebaseAuth.instance
                    .signOut()
                    .then((action) {
                      Navigator.of(context)
                      .pushReplacementNamed('/landing');
                    })
                    .catchError((e) {
                      print(e);
                    });
                  },
                ),
                height: 55.0,
              ),
            ),
          ),
        ), 
        body: voteList(),
        
      );
    }
    Widget voteList() {
    if (votes != null) {
      return StreamBuilder(
        stream: votes,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, i) {
                String title = snapshot.data.documents[i].data['title'];
                String description = snapshot.data.documents[i].data['description'];
                int vote = snapshot.data.documents[i].data['vote'];
                bool voted = true;
                return new Card(
                  child: ListTile(
                    title: Text(title),
                    subtitle: Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // trailing: Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: <Widget>[
                    //     IconButton(
                    //       icon: Icon(FontAwesomeIcons.edit),
                    //       onPressed: () {
                    //         updateDialog(context, snapshot.data.documents[i].documentID);
                    //       },
                    //     ),
                    //     IconButton(
                    //       icon: Icon(Icons.delete_forever),
                    //       onPressed: () {
                    //         crudObj.deleteData(snapshot.data.documents[i].documentID);
                    //       },
                    //     ),
                    //   ],
                    // ),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite),
                      color:  Colors.red,
                      onPressed: () {
                        // voted ? 
                        
                        crudObj.updateVoteData(snapshot.data.documents[i].documentID, {
                          'vote': vote + 1
                        })
                        // : cantVoteDialog(context);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IdeaDetailsScreen(title, description, vote)
                        )
                      );
                    },
                    onLongPress: () {
                      updateDialog(context, snapshot.data.documents[i].documentID);
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                children: <Widget>[
                  Text('No Ideas Found, Please Add A New Idea'),
                  RaisedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text("Add New Idea"),
                    onPressed: (){
                      addDialog(context);
                    },
                  )
                ],
              ),
            );
          }
        },
      );
    } else {
      return Center(
        child: Column(
          children: <Widget>[
            CircularProgressIndicator(),
            Text('Loading, Please wait..')
          ],
        ),
      );
    }
  }
    
  Future<bool>cantVoteDialog(BuildContext context) async 
    {
      return showDialog(context: context, barrierDismissible: false,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text('Vote Idea'),
            content: Text('Sorry You can\'t vote Twice'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }

      );
    }
  
    Future<bool>addDialog(BuildContext context) async 
    {
      return showDialog(context: context, barrierDismissible: false,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text('Add Data'),
            content: Column(
              children: <Widget>[
                TextField(decoration: InputDecoration(hintText: 'Enter Idea Title'),
                onChanged: (value){
                  this.ideaTitle = value;
                },),
                Padding(padding: EdgeInsets.all(10.0),),
                TextField(decoration: InputDecoration(hintText: 'Enter Idea Description'),
                onChanged: (value){
                  this.description = value;
                },),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add'),
                textColor: Colors.blue,
                onPressed: () {
                  crudObj.addData({
                    'title': this.ideaTitle,
                    'description': this.description,
                    'vote': 0
                  }).then((result) {
                    dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }

      );
    }
   
    Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Vote Idea', style: TextStyle(fontSize: 15.0)),
            content: Text('Idea Added Successfully'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }


  Future<bool>updateDialog(BuildContext context,selectedDoc) async 
    {
      return showDialog(context: context, barrierDismissible: false,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Text('Update Data'),
            content: Column(
              children: <Widget>[
                TextField(decoration: InputDecoration(hintText: 'Update Your Idea Title'),
                onChanged: (value){
                  this.ideaTitle = value;
                },),
                Padding(padding: EdgeInsets.all(10.0),),
                TextField(decoration: InputDecoration(hintText: 'Update Your Idea Description'),
                onChanged: (value){
                  this.description = value;
                },),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () {
                  crudObj.updateData(selectedDoc,{
                    'title': this.ideaTitle,
                    'description': this.description
                  }).then((result) {
                   // dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }

      );
    }
  }
    