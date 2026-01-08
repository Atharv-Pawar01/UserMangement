import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
    await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: "AIzaSyBF-VQLucboQ4EQlYtUlq1fNWXTttW9rSY",
        authDomain: "user-management-f4fa7.firebaseapp.com",
        projectId: "user-management-f4fa7",
        storageBucket: "user-management-f4fa7.firebasestorage.app",
        messagingSenderId: "842747618454",
        appId: "1:842747618454:web:24799b3c13fad0bc110eb7",
        measurementId: "G-PX7X3NJ0JK"));
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const DashboardScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
