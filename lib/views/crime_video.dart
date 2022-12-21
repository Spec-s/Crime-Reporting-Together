// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crimereporting/services/auth/firebase_auth_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';

class CrimeVideos extends StatefulWidget {
  const CrimeVideos({super.key});

  @override
  State<CrimeVideos> createState() => _CrimeVideosState();
}

class _CrimeVideosState extends State<CrimeVideos> {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuthProvider().currentUser!.id;
    File? _video;
    final imagePicker = ImagePicker();
    String downloadURL;

//Building the snackbar for displaying errors

    showSnackBar(String snacktext, Duration d) {
      final snackBar = SnackBar(content: Text(snacktext), duration: d);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    //Selecting the image
    Future imagePickerModel() async {
      // picking the video to upload to firestore database
      final selectedvideo =
          await imagePicker.pickVideo(source: ImageSource.gallery);

      setState(() async {
        if (selectedvideo != null) {
          _video = File(selectedvideo.path);

          // uploading Image to FireStorage

          final postId = DateTime.now()
              .millisecondsSinceEpoch
              .toString(); // adding time to the image
          Reference ref = FirebaseStorage.instance
              .ref()
              .child("$userId/Crime_Videos")
              .child("post_$postId");
          await ref.putFile(_video!);
          downloadURL = await ref.getDownloadURL();

          // Adding the image link to Firestore to show the connection with the user
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          await firestore
              .collection("Crime_Videos")
              .doc()
              .set({'downloadURL': downloadURL});

          showSnackBar(
            'video was uploaded successfully :)',
            Duration(seconds: 3),
          );
        } else {
          // Showing Snack Bar with the errors
          showSnackBar(
            'No video was selected',
            Duration(milliseconds: 400),
          );
        }
      });
    }

    Future camerauploadvidoe() async {
      final selectedvideo =
          await imagePicker.pickVideo(source: ImageSource.camera);

      setState(() async {
        if (selectedvideo != null) {
          _video = File(selectedvideo.path);

          // uploading Image to FireStorage

          final postId = DateTime.now()
              .millisecondsSinceEpoch
              .toString(); // adding time to the image
          Reference ref = FirebaseStorage.instance
              .ref()
              .child("$userId/Crime_Videos")
              .child("post_$postId");
          await ref.putFile(_video!);
          downloadURL = await ref.getDownloadURL();

          // Adding the image link to Firestore to show the connection with the user
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          await firestore
              .collection("Crime_Videos")
              .doc()
              .set({'downloadURL': downloadURL});

          showSnackBar(
            'video was uploaded successfully :)',
            Duration(seconds: 3),
          );
        } else {
          // Showing Snack Bar with the errors
          showSnackBar(
            'No video was selected',
            Duration(milliseconds: 400),
          );
        }
      });
    }

    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Expanded(
              child: VideoPlayerView(
                  url: "img/AugIntro", dataSourceType: DataSourceType.asset),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          backgroundColor: Colors.pinkAccent,
          buttonSize: Size(70, 70),
          foregroundColor: Colors.amber,
          spaceBetweenChildren: 15,
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
              onTap: () => camerauploadvidoe(),
            )
          ],
        ),
      ),
    );
  }
}

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    required this.url,
    required this.dataSourceType,
  });

  final String url;
  final DataSourceType dataSourceType;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();

    switch (widget.dataSourceType) {
      case DataSourceType.network:
        _videoPlayerController = VideoPlayerController.network(widget.url);
        break;
      case DataSourceType.asset:
        _videoPlayerController = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.file:
        _videoPlayerController = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.contentUri:
        _videoPlayerController =
            VideoPlayerController.contentUri(Uri.parse(widget.url));
        break;
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(controller: _chewieController),
        ),
        StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('Crime_Videos').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.hasData
                ? VideoPlayerView(
                    // ignore: unnecessary_string_interpolations
                    url: "$url",
                    dataSourceType: DataSourceType.network,
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  );
          },
        ),
      ],
    );
  }
}
