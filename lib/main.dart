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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: theme),
        useMaterial3: true,
      ),
      // home: const HomePage(),
    );
  }
}
