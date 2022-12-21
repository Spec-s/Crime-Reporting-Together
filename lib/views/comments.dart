// ignore_for_file: use_key_in_widget_constructors, no_logic_in_create_state, unnecessary_this, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crimereporting/services/auth/firebase_auth_provider.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String? postMediaUrl;

  Comments(
      {required this.postId,
      required this.postOwnerId,
      required this.postMediaUrl});

  @override
  State<Comments> createState() => CommentsState(
      postId: this.postId,
      postOwnerId: this.postOwnerId,
      postMediaUrl: this.postMediaUrl);
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postOwnerId;
  final String? postMediaUrl;

  CommentsState(
      {required this.postId,
      required this.postOwnerId,
      required this.postMediaUrl});

  addComment() {
    FirebaseFirestore.instance
        .collection("Comments")
        .doc()
        .collection('Missing_persons')
        .add({
      "comments": commentController.text,
      "writtenBy": FirebaseAuthProvider().currentUser!.id,
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("Comments").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return Column(
                children: <Widget>[
                  ListTile(),
                  Divider(),
                ],
              );
            },
          )),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: 'Write a comment'),
            ),
            trailing: MaterialButton(
              elevation: 2,
              onPressed: addComment(),
              child: Text("Post"),
            ),
          ),
        ],
      ),
    );
  }
}
