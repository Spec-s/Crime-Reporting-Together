// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:crimereporting/services/CRUD_DB/crud_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

// this file deals explicitly with the database for all CRUD operation and
//getting the path for the directory where the files will be stored etc.
//

class MediaService {
  Database? _db;

  

  Future<int> deleteAllPhoto() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(photoTable);
  }

  Future<void> deletePhoto({required int photoid}) async {
    final db = _getDatabaseOrThrow();
    final deletedPhoto = await db.delete(
      photoTable,
      where: 'photoid = ?',
      whereArgs: [photoid],
    );

    if (deletedPhoto == 0) {
      throw CouldNotDeletePhotoException();
    }
  }

  Future<PhotoDb> createPhoto({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    // check to ensure that the owner exists in the database with the correct email
    final dbUser = await getUser(email: owner.userEmail);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }

    const pname = '';
    const pPath = '';
    const location = '';
    // Creating the details for the photo
    final photoId = await db.insert(photoTable, {
      photoIdColumn: owner.userId,
      photoNameColumn: pname,
      finalpathColumn: pPath,
      uploadedByColumn: owner.userEmail,
      locationColumn: location,
    });

    final photo = PhotoDb(
      photoId: photoId,
      photoName: pname,
      filepath: pPath,
      uploadedBy: owner.userId,
      location: location,
    );

    return photo;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email =?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email =?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final userId = await db.insert(userTable, {
      userEmailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      userId: userId,
      userEmail: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedUser = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (deletedUser != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(
          docsPath.path, dbName); // getting the actual location of the database
      final db = await openDatabase(dbPath); // opening the database
      _db = db; // assigning the database to our created database

      // Create User Table
      await db.execute(createUserTable);

      // Create Photo Table
      await db.execute(createPhotoTable);

      // Create Video Table
      await db.execute(createVideoTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsException();
    }
  }
}

@immutable
class DatabaseUser {
  final int userId;
  final String userEmail;

  const DatabaseUser({
    required this.userId,
    required this.userEmail,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : userId = map[userIdColumn] as int,
        userEmail = map[userEmailColumn] as String;

  // allow the option to print the data as readable texts
  @override
  String toString() => 'Person, ID = $userId, email = $userEmail';

  @override
  bool operator ==(covariant DatabaseUser other) => userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

class PhotoDb {
  final int photoId;
  final String photoName;
  final String filepath;
  final int uploadedBy;
  final String location;

  PhotoDb({
    required this.photoId,
    required this.photoName,
    required this.filepath,
    required this.uploadedBy,
    required this.location,
  });

  PhotoDb.fromRow(Map<String, Object?> map)
      : photoId = map[photoIdColumn] as int,
        photoName = map[photoNameColumn] as String,
        filepath = map[finalpathColumn] as String,
        uploadedBy = map[uploadedByColumn] as int,
        location = map[locationColumn] as String;

  @override
  String toString() =>
      'peoplePhoto, ID = $photoId, name = $photoName, file = $filepath, uploadedBy = $uploadedBy, location = $location ';

  @override
  bool operator ==(covariant PhotoDb other) => photoId == other.photoId;

  @override
  int get hashCode => photoId.hashCode;
}

class VideoRecording {
  final int vidId;
  final String filepath;
  final String uploadedBy;
  final String videoName;
  final int views;
  final String location;

  VideoRecording(
      {required this.vidId,
      required this.filepath,
      required this.uploadedBy,
      required this.videoName,
      required this.views,
      required this.location});

  @override
  String toString() =>
      'Videos, ID =$vidId, name = $videoName, file = $filepath, uploadedBy = $uploadedBy, location = $location, views = $views';
  @override
  bool operator ==(covariant VideoRecording other) => vidId == other.vidId;

  @override
  int get hashCode => vidId.hashCode;
}

const dbName = 'media.db';
const photoTable = 'photoDb';
const videoTable = 'videotable';
const userTable = 'user';
const userIdColumn = 'userId';
const vidIdColumn = 'vidId';
const videoNameColumn = 'videoname';
const userEmailColumn = 'userEmail';
const photoIdColumn = 'photoId';
const photoNameColumn = 'photoName';
const finalpathColumn = 'filepath';
const uploadedByColumn = 'uploadedBy';
const locationColumn = 'location';
const viewsColumn = 'Views';

const createUserTable = '''CREATE TABLE IF NOT EXISTS "userTable" (
	      "userId"	INTEGER NOT NULL,
	      "userEmail"	TEXT NOT NULL UNIQUE,
	      PRIMARY KEY("userId" AUTOINCREMENT)
      );''';

const createPhotoTable = '''CREATE TABLE IF NOT EXISTS "photoTable" (
	      "photoId"	INTEGER NOT NULL,
	      "photoName"	TEXT,
	      "filepath"	TEXT,
	      "uploadedBy"	INTEGER NOT NULL,
	      "location"	TEXT,
	      FOREIGN KEY("uploadedBy") REFERENCES "userTable"("userId"),
	      PRIMARY KEY("photoId" AUTOINCREMENT)
        ); ''';

const createVideoTable = '''CREATE TABLE IF NOT EXISTS "videoRecording" (
	      "vidId"	INTEGER NOT NULL,
	      "filepath"	TEXT NOT NULL,
	      "uploadedBy"	INTEGER NOT NULL,
	      "comments"	TEXT,
	      "videoName"	TEXT NOT NULL,
	      "views"	INTEGER,
	      "location"	TEXT,
	      FOREIGN KEY("uploadedBy") REFERENCES "userTable"("userId"),
	      PRIMARY KEY("vidId" AUTOINCREMENT)
        ); ''';
