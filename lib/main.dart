import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timer_meet/controllers/auth_controller.dart';
import 'package:timer_meet/firebase_options.dart';
import 'package:timer_meet/routes.dart';
import 'package:timer_meet/screens/home_screen.dart';
import 'package:timer_meet/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
      ),
      onGenerateRoute: MyRoutes.onGeneratedRoutes,
      home: StreamBuilder(
        stream: Authentication().authChanges,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapShot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
