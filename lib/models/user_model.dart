import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jan_app_flutter/providers/auth_provider.dart';

class PhotoModel {
  final String path;
  final String url;

  PhotoModel({this.path, this.url});

  factory PhotoModel.fromData(Map<String, dynamic> data) {
    return PhotoModel(
      path: data["path"],
      url: data["url"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'url': url,
    };
  }
}

class UserModel with ChangeNotifier {
  String uid;
  String phoneNumber;
  String gender;
  String firstName;
  DateTime dateOfBirth;
  String photoUrl;
  List<String> knownLanguages = [];
  int height;
  List<PhotoModel> photos = [];
  int weight;
  String about;
  DocumentReference education;
  DocumentReference occupation;
  DocumentReference zodiacSign;
  DocumentReference maritalStatus;
  DocumentReference kids;
  DocumentReference sport;
  DocumentReference alcohol;
  DocumentReference smoking;
  bool wasTutorialViewed;
  int swipesCount = 0;
  DateTime swipesResetDateTime = DateTime.now();
  Map<String, bool> notifications;
  String address;
  Map<String, dynamic> position;
  int maxDistance;
  Timestamp lastmsg;

  UserModel({
    this.uid,
    this.phoneNumber,
    this.gender,
    this.firstName,
    this.dateOfBirth,
    this.knownLanguages,
    this.height,
    this.photoUrl,
    this.photos,
    this.weight,
    this.about,
    this.education,
    this.occupation,
    this.zodiacSign,
    this.maritalStatus,
    this.kids,
    this.sport,
    this.alcohol,
    this.smoking,
    this.wasTutorialViewed,
    this.swipesCount = 0,
    this.swipesResetDateTime,
    this.notifications,
    this.address,
    this.position,
    this.maxDistance,
  });

  factory UserModel.fromFireBase(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      phoneNumber: firebaseUser.phoneNumber,
    );
  }

  factory UserModel.fromDocument(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      phoneNumber: data["phoneNumber"],
      gender: data["gender"],
      firstName: data["firstName"],
      dateOfBirth:
          data["dateOfBirth"] != null ? data["dateOfBirth"].toDate() : null,
      knownLanguages: data["knownLanguages"] != null
          ? (data["knownLanguages"] as List<dynamic>)
              .map((e) => e as String)
              .toList()
          : [],
      height: data["height"],
      photos: data["photos"] != null
          ? (data["photos"] as List<dynamic>)
              .map((e) => PhotoModel.fromData(e))
              .toList()
          : [],
      photoUrl: data["photoUrl"],
      weight: data["weight"],
      about: data["about"],
      education: data["education"],
      occupation: data["occupation"],
      zodiacSign: data["zodiacSign"],
      maritalStatus: data["maritalStatus"],
      kids: data["kids"],
      sport: data["sport"],
      alcohol: data["alcohol"],
      smoking: data["smoking"],
      wasTutorialViewed: data["wasTutorialViewed"] as bool,
      swipesCount: data["swipesCount"],
      swipesResetDateTime: data["swipesResetDateTime"] != null
          ? data["swipesResetDateTime"].toDate()
          : null,
      notifications: data["notifications"],
      address: data["address"],
      position: data["position"],
      maxDistance: data["maxDistance"] ?? default_distance,
    );
  }

  Map<String, dynamic> toMap() {
    final List<Map<String, dynamic>> photosMap =
        photos.map((e) => e.toMap()).toList();

    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'firstName': firstName,
      'dateOfBirth': dateOfBirth,
      'knownLanguages': knownLanguages,
      'height': height,
      'photoUrl': photoUrl,
      'about': about,
      'zodiac-sign': zodiacSign,
      'sport': sport,
      'marital-status': maritalStatus,
      'alcohol': alcohol,
      'smoking': smoking,
      'kids': kids,
      'occupation': occupation,
      'education': education,
      'weight': weight,
      'wasTutorialViewed': wasTutorialViewed,
      'swipesCount': swipesCount,
      'swipesResetDateTime': swipesResetDateTime,
      'notifications': notifications,
      'address': address,
      'position': position,
      'maxDistance': maxDistance ?? default_distance,
      'photos': photosMap,
    };
  }

  Map<String, dynamic> toMapWithField(String field, dynamic value) {
    return {
      field: value,
    };
  }

  void setPhotos(List<PhotoModel> photos) {
    this.photos = photos;
    if (photos.length > 0) {
      this.photoUrl = photos.first.url;
    }
    notifyListeners();
  }

  void setKnownLanguages(value) {
    knownLanguages = value;
    notifyListeners();
  }

  void setHeight(int height) {
    this.height = height;
    notifyListeners();
  }

  void setWeight(value) {
    weight = value;
    notifyListeners();
  }

  void setEducation(value) {
    education = value;
    notifyListeners();
  }

  void setOccupation(value) {
    occupation = value;
    notifyListeners();
  }

  void setSmoking(value) {
    smoking = value;
    notifyListeners();
  }

  void setAlcohol(value) {
    alcohol = value;
    notifyListeners();
  }

  void setSport(value) {
    sport = value;
    notifyListeners();
  }

  void setMaritalStatus(value) {
    maritalStatus = value;
    notifyListeners();
  }

  void setKids(value) {
    kids = value;
    notifyListeners();
  }

  void setZodiacSign(value) {
    zodiacSign = value;
    notifyListeners();
  }

  void setMaxDistance(value) {
    maxDistance = value;
    notifyListeners();
  }
}
