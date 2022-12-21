// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crimereporting/services/auth/firebase_auth_provider.dart';
import 'package:crimereporting/views/comments.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class MissingPersonstest extends StatefulWidget {
  const MissingPersonstest({super.key});

  @override
  State<MissingPersonstest> createState() => _MissingPersonstestState();
}

class _MissingPersonstestState extends State<MissingPersonstest> {
  @override
  Widget build(BuildContext context) {
    final isDialOpen = ValueNotifier(false);
    String userId = FirebaseAuthProvider().currentUser!.id;
    final postId = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // adding time to the image
    File? _image;
    final imagePicker = ImagePicker();
    String? downloadURL;
    Position? _position;

    Future<Position> _determinePosition() async {
      LocationPermission permission;

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return Future.error('Location permission were denied');
        }
      }

      return await Geolocator.getCurrentPosition();
    }

    void getCurrentLocation() async {
      // this function will fetch the current location

      Position position = await _determinePosition();

      setState(() {
        _position = position;
      });
    }

//Building the snackbar for displaying errors

    showSnackBar(String snacktext, Duration d) {
      final snackBar = SnackBar(content: Text(snacktext), duration: d);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    //Selecting the image
    Future imagePickerModel() async {
      // picking the image to upload to firestore database
      final selectedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      setState(() async {
        if (selectedImage != null) {
          _image = File(selectedImage.path);

          // uploading Image to FireStorage

          Reference ref = FirebaseStorage.instance
              .ref()
              .child("$userId/Missing_Person_Images")
              .child("post_$postId");
          await ref.putFile(_image!);
          downloadURL = await ref.getDownloadURL();

          // Adding the image link to Firestore to show the connection with the user
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          await firestore.collection('Missing_persons').doc().set({
            "downloadURL": downloadURL,
            "postid": postId,
          });

          showSnackBar(
            'Image uploaded successfully :)',
            Duration(seconds: 3),
          );
        } else {
          // Showing Snack Bar with the errors
          showSnackBar(
            'No image selected',
            Duration(milliseconds: 400),
          );
        }
      });
    }

    Future cameraImage() async {
      final selectedImage =
          await imagePicker.pickImage(source: ImageSource.camera);

      setState(() async {
        if (selectedImage != null) {
          _image = File(selectedImage.path);

          // uploading Image to FireStorage

          final postId = DateTime.now()
              .millisecondsSinceEpoch
              .toString(); // adding time to the image
          Reference ref = FirebaseStorage.instance
              .ref()
              .child("$userId/Missing_Person_Images")
              .child("post_$postId");
          await ref.putFile(_image!);
          downloadURL = await ref.getDownloadURL();

          // Adding the image link to Firestore to show the connection with the user
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          await firestore.collection('Missing_persons').doc().set({
            "downloadURL": downloadURL,
            "postID": postId,
            "uploadedBy": userId,
            "position": _position
          });

          // sending email to the specific individual
         // sendEmail(downloadURL!);

          showSnackBar(
            'Image uploaded successfully :)',
            Duration(seconds: 3),
          );
        } else {
          // Showing Snack Bar with the errors
          showSnackBar(
            'No image selected',
            Duration(milliseconds: 400),
          );
        }
      });
    }

    showComments(BuildContext context,
        {required String postId,
        required String ownerId,
        required String? mediaUrl}) {
      Navigator.push(context, MaterialPageRoute(builder: ((context) {
        return Comments(
            postId: postId, postOwnerId: ownerId, postMediaUrl: mediaUrl);
      })));
    }

    imagefooter() {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
              GestureDetector(
                onTap: () => showComments(
                  context,
                  postId: postId,
                  ownerId: userId,
                  mediaUrl: downloadURL,
                ),
                child: Icon(
                  Icons.chat,
                  size: 28.0,
                  color: Colors.blue[900],
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Missing_persons')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                QueryDocumentSnapshot x = snapshot.data!.docs[i];

                return snapshot.hasData
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Image.network(x['downloadURL'],
                                    fit: BoxFit.contain),
                                Padding(padding: EdgeInsets.all(16.0)),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                            imagefooter()
                          ])
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            );
          }),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_home,
        backgroundColor: Colors.pinkAccent,
        buttonSize: Size(70, 70),
        foregroundColor: Colors.amber,
        spaceBetweenChildren: 15,
        openCloseDial: isDialOpen,
        children: [
          SpeedDialChild(
            child: Icon(Icons.image),
            backgroundColor: Colors.green,
            label: 'Gallery',
            onTap: () => imagePickerModel(),
          ),
          SpeedDialChild(
              child: Icon(Icons.camera),
              backgroundColor: Color.fromARGB(255, 84, 171, 243),
              label: 'Camera',
              onTap: () {
                cameraImage();
                _determinePosition();
              })
        ],
      ),
    );
  }
}
