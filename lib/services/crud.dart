import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

  class CrudMethods
  {
      bool isLoggedIn()
     {
      if(FirebaseAuth.instance.currentUser() != null) {return true;}
      else{ return false; }    
     }

      Future<void>addData(voteData) async 
      {
        if(isLoggedIn()){
          Firestore.instance.collection('/Votes').add(voteData).catchError((e){
            print(e);
          }); 
        }
        else{ print('NEED LOGIN'); }
      }
      
      getData() async 
      {
        return Firestore.instance.collection('/Votes').snapshots();
      }
      
      updateData(selectedDoc, newValues) async
      {
        Firestore.instance
        .collection('Votes')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e){
          print(e);
        });
      }

      updateVoteData(docID, newValue) async
      {
        Firestore.instance
        .collection('Votes')
        .document(docID)
        .updateData(newValue)
        .catchError((e){
          print(e);
        });
      }

      deleteData(docID)
      {
        Firestore.instance
        .collection('Votes')
        .document(docID)
        .delete()
        .catchError((e){
          print(e);
        });
      }
  }