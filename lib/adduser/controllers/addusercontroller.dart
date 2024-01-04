import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employeeblacklistdata/homepage/controllers/homecontroller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

late StreamController<AddUserData> addUserController;
late Stream<AddUserData> addUserStream;
AddUserData addUSerData = AddUserData('', false, []);

final ImagePicker picker = ImagePicker();

class AddUserController {
  //start stream

  startStream() {
    addUserController = StreamController();
    addUserStream = addUserController.stream.asBroadcastStream();
    addUSerData = AddUserData('', false, []);
  }

  //pick images for user blacklist

  pickImages() async {
    List<XFile> pickedFile =
        await picker.pickMultiImage(maxHeight: 600, maxWidth: 600);
    if (pickedFile.isNotEmpty) {
      addUSerData.images.clear();
      for (var element in pickedFile) {
        var val = await element.readAsBytes();
        addUSerData.images.add(base64Encode(val));
        addUserController.add(addUSerData);
      }
    }
  }

  // add black list data to database

  addBlackListData(name, aadhar, issues, context) async {
    try {
      await FirebaseFirestore.instance
          .collection('blacklists')
          .doc('$aadhar::${homeData.userData['email']}')
          .set({
        'aadhar': aadhar,
        'name': name,
        'issues': issues,
        'images': addUSerData.images,
        'added_by': homeData.userData['email'],
        'company': homeData.userData['company']
      });
      await HomeController().getMyIssues();
      homeController.add(homeData);

      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class AddUserData {
  String error;
  bool loading;
  List images;
  AddUserData(this.error, this.loading, this.images);
}
