import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employeeblacklistdata/homepage/controllers/homecontroller.dart';
import 'package:employeeblacklistdata/sharedpref/sharedpref.dart';
import 'package:flutter/material.dart';

late StreamController<LoginData> loginController;
late Stream<LoginData> loginStream;
late LoginData loginData;

class LoginController {
  //start stream

  startStream() {
    loginController = StreamController();
    loginStream = loginController.stream.asBroadcastStream();
    loginData = LoginData('', false, false);
  }

  //register user

  registerUser(name, company, phone, email, password, context) async {
    try {
      var userCheck = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (userCheck.docs.isNotEmpty) {
        loginData.error = 'User already exist with this email';
        loginController.add(loginData);
      } else {
        await FirebaseFirestore.instance.collection('users').doc(email).set({
          'name': name,
          'company': company,
          'email': email,
          'password': password,
          'phone': phone,
          'emailpass': '$email::$password',
          'role': 'user',
          'status': '0'
        });
        await setLocalData('user', '$email::$password');
        HomeController().getUserData();
        Navigator.pop(context);
      }
    } catch (e) {
      loginData.error = e.toString();
      loginController.add(loginData);
    }
  }

  //login user

  login(email, password, context) async {
    try {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .where('emailpass', isEqualTo: '$email::$password')
          .get();
      if (userData.docs.isNotEmpty) {
        for (final val in userData.docs) {
          homeData.userData = val.data();
          await setLocalData('user', '$email::$password');
        }
        homeData.searchList.clear();
        homeData.searches = '';
        if (homeData.userData['role'] == 'admin') {
          await HomeController().getEmployers();
          homeData.blacklists.clear();
        } else {
          await HomeController().getMyIssues();
          homeData.employers.clear();
        }
        homeController.add(homeData);
        Navigator.pop(context);
      } else {
        loginData.error = 'Please enter correct login credentials';
        loginController.add(loginData);
      }
    } catch (e) {
      loginData.error = e.toString();
      loginController.add(loginData);
    }
  }
}

class LoginData {
  String error;
  bool register;
  bool loading;
  LoginData(this.error, this.register, this.loading);
}
