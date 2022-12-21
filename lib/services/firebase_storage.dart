
import 'package:firebase_storage/firebase_storage.dart';


  /* Future uploadImage() async {
    final postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("$userId/Wanted_Person_Images")
        .child("post_$postId");
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();
  } */

// Points to the root reference
final storageRef = FirebaseStorage.instance.ref().child("Wanted_Person_Images/");

