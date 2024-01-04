import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employeeblacklistdata/sharedpref/sharedpref.dart';
import 'package:flutter/material.dart';

late StreamController<HomeData> homeController;
late Stream<HomeData> homeStream;
HomeData homeData = HomeData('', false, {}, [], [], '', [], [], '');

class HomeController {
  //start stream

  startStream() {
    homeController = StreamController();
    homeStream = homeController.stream.asBroadcastStream();
  }

  //get current users data from database

  getUserData() async {
    var user = await getLocalData('user');
    if (user != null) {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .where('emailpass', isEqualTo: user)
          .get();
      if (userData.docs.isNotEmpty) {
        for (final val in userData.docs) {
          homeData.userData = val.data();
          if (homeData.userData['role'] == 'admin') {
            await getEmployers();
            homeData.blacklists.clear();
          } else {
            await getMyIssues();
            homeData.employers.clear();
          }
        }
      } else {
        await removeLocalData('user');
      }
      homeController.add(homeData);
    }
  }

  //logout current user

  logout() async {
    homeData.userData.clear();
    homeData.blacklists.clear();
    homeData.employeeList.clear();
    homeData.employers.clear();
    homeData.searchList.clear();
    await removeLocalData('user');
    homeController.add(homeData);
  }

  //search employees from blacklist database

  searchEmployee(aadhar) async {
    try {
      homeData.searchList.clear();
      homeData.searches = '';
      var blist = await FirebaseFirestore.instance
          .collection('blacklists')
          .where('aadhar', isEqualTo: aadhar)
          .get();
      if (blist.docs.isNotEmpty) {
        for (final v in blist.docs) {
          homeData.searchList.add(v.data());
        }
        homeData.searches =
            '${homeData.searchList.length} company has marked him in a Blacklist';
        homeController.add(homeData);
      } else {
        homeData.searches =
            '${homeData.searchList.length} company has marked him in a Blacklist';
        homeController.add(homeData);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get registered users data from datasbe for admin

  getEmployers() async {
    try {
      homeData.employers.clear();
      var users = await FirebaseFirestore.instance.collection('users').get();
      if (users.docs.isNotEmpty) {
        for (final val in users.docs) {
          if (val.data()['role'] != 'admin') {
            homeData.employers.add(val.data());
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get blacklist users added by current user

  getMyIssues() async {
    try {
      homeData.blacklists.clear();
      var val = await FirebaseFirestore.instance
          .collection('blacklists')
          .where('added_by', isEqualTo: homeData.userData['email'])
          .get();
      if (val.docs.isNotEmpty) {
        List blackList = [];
        for (var v in val.docs) {
          blackList.add(v.data());
        }
        homeData.blacklists = blackList;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //remove user from the blacklist

  removeFromBlackList(id) async {
    try {
      await FirebaseFirestore.instance
          .collection('blacklists')
          .doc(id)
          .delete();
      await getMyIssues();
      homeController.add(homeData);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // approve or decline registered user by admin

  statusUpdate(email, status) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .update({'status': status});
      await getEmployers();
      homeController.add(homeData);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class HomeData {
  String error;
  bool loading;
  Map userData;
  List employeeList;
  List employers;
  String view;
  List blacklists;
  List searchList;
  String searches;
  HomeData(
      this.error,
      this.loading,
      this.userData,
      this.employeeList,
      this.employers,
      this.view,
      this.blacklists,
      this.searchList,
      this.searches);
}
