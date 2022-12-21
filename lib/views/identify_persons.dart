// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable, unused_import, avoid_unnecessary_containers, unnecessary_null_comparison, sized_box_for_whitespace
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class IdentifyPerson extends StatefulWidget {
  const IdentifyPerson({super.key});

  @override
  State<IdentifyPerson> createState() => _IdentifyPersonState();
}

class _IdentifyPersonState extends State<IdentifyPerson> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 3,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'img/model_unquant.tflite',
      labels: 'img/labels.txt',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  pickCameraImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.pink[200],
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                'Identifying People',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              SizedBox(height: 20),
              Center(
                heightFactor: 1.0,
                child: _loading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.orange),
                        backgroundColor: Colors.blue,
                        color: Colors.green[600],
                        semanticsLabel: 'No Image',
                      )
                    : Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 300,
                              child: Image.file(_image),
                            ),
                            SizedBox(height: 10),
                            _output != null
                                ? Text(
                                    "${_output[0]['label']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                : Container(
                                    child: Text("No data to be displayed"),
                                  )
                          ],
                        ),
                      ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pickCameraImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 250,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue[300]),
                        child: Text(
                          'Take a photo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        pickGalleryImage();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 250,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue[300]),
                        child: Text(
                          'Gallery',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
