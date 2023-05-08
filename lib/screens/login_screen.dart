import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timer_meet/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.deepPurple.shade900,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
              statusBarColor: Colors.transparent)),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
            Colors.deepPurple.shade800,
            Colors.deepPurple.shade900,
          ], stops: const [
            0.0,
            2.0
          ]),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                "assets/images/Logo.png",
                width: 200,
              ),
            ),
            SizedBox(
              height: 200,
            ),
            GestureDetector(
              onTap: () async {
                bool status = await Authentication().signInWithGoogle();
                if (status) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/home", (route) => false);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icons/google.png",
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Login with Google",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
