import 'package:employeeblacklistdata/adduser/ui/adduser.dart';
import 'package:employeeblacklistdata/homepage/ui/homepage.dart';
import 'package:employeeblacklistdata/login/ui/loginpage.dart';
import 'package:employeeblacklistdata/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBJuoQ_1B09cIBh1jx8RUA8fxRlkllO2o8",
          authDomain: "employee-blacklist-data.firebaseapp.com",
          projectId: "employee-blacklist-data",
          storageBucket: "employee-blacklist-data.appspot.com",
          messagingSenderId: "879068654419",
          appId: "1:879068654419:web:58f223d71c973465c00fa6"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/add-user': (context) => const AddUser()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: theme),
        useMaterial3: true,
      ),
      // home: const HomePage(),
    );
  }
}
